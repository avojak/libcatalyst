/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * The HttpUtils namespace contains useful functions for executing HTTP requests.
 */
namespace Catalyst.HttpUtils {

    private const string HTTP_GET = "GET";
    private const int BUFFER_SIZE = 512;

    /**
     * Downloads the file at the given URL.
     *
     * @param context a {@link Catalyst.Http.DownloadContext} providing request details as well
     *      as a means of tracking progress and signaling completion/failure
     * @param cancellable a {@link GLib.Cancellable}
     */
    public static void download_file_sync (Catalyst.Http.DownloadContext context,
            GLib.Cancellable? cancellable = null) {
        // Create the session
        var session = new Soup.Session ();
        GLib.Uri uri;
        try {
            uri = GLib.Uri.parse (context.url, GLib.UriFlags.NONE);
        } catch (GLib.UriError e) {
            context.failed ("Invalid URI: %s".printf (context.url));
            return;
        }

        // Send the request and obtain the input stream
        var message = new Soup.Message.from_uri (HTTP_GET, uri);
        GLib.DataInputStream input_stream;
        try {
            input_stream = new GLib.DataInputStream (session.send (message, cancellable));
        } catch (GLib.Error e) {
            context.failed ("Error while sending the download request: %s".printf (e.message));
            return;
        }

        // Check for an HTTP status code indicating failure
        if (is_error (message.status_code)) {
            context.failed (message.reason_phrase, message.status_code);
            return;
        }

        // Get the total size of the file based on the Content-Length header
        int64 total_bytes = message.response_headers.get_content_length ();

        // Obtain the output stream for the target output file
        GLib.FileOutputStream output_stream;
        try {
            output_stream = context.output_file.replace (null, false, GLib.FileCreateFlags.NONE, cancellable);
        } catch (GLib.Error e) {
            context.failed ("Error creating output stream: %s".printf (e.message));
            return;
        }

        // Read the file from the input stream and immediately write the buffer to the output file
        try {
            int64 bytes_read = 0;
            GLib.Bytes bytes;
            while ((bytes = input_stream.read_bytes (BUFFER_SIZE, cancellable)).length != 0) {
                try {
                    output_stream.write_bytes (bytes, cancellable);
                } catch (GLib.Error e) {
                    context.failed ("Error writing to output stream: %s".printf (e.message));
                    return;
                }

                // Update progress
                bytes_read += bytes.length;
                context.progress (bytes_read, total_bytes);
            }
        } catch (GLib.Error e) {
            context.failed ("Error reading from input stream: %s".printf (e.message));
            return;
        }

        context.complete ();
    }

    /**
     * Downloads the file at the given URL asynchronously.
     *
     * ''Example''<<BR>>
     * {{{
     * public static int main (string[] args) {
     *     var url = "https://example.com/foo.tgz";
     *     var output_file = GLib.File.new_for_path ("./foo.tgz");
     *     var context = new Catalyst.Http.DownloadContext (url, output_file);
     *     context.progress.connect ((bytes_read, total_bytes) => {
     *         // ...
     *     });
     *     context.complete.connect (() => {
     *         // ...
     *     });
     *     context.failed.connect ((message, status_code) => {
     *         // ...
     *     });
     *     Catalyst.HttpUtils.download_file_async.begin (context, null, (obj, res) => {
     *         Catalyst.HttpUtils.download_file_async.end (res);
     *     });
     *     return 0;  
     * }
     * }}}
     *
     * @param context a {@link Catalyst.Http.DownloadContext} providing request details as well as a means of tracking
     *      progress and signaling completion/failure
     * @param cancellable a {@link GLib.Cancellable}
     */
    public static async void download_file_async (Catalyst.Http.DownloadContext context,
            GLib.Cancellable? cancellable = null) {
        GLib.SourceFunc callback = download_file_async.callback;
        new GLib.Thread<void> ("download", () => {
            download_file_sync (context, cancellable);
            Idle.add ((owned) callback);
        });
        yield;
    }

    /**
     * Retrieves the content at the given URL as a string.
     *
     * @param url The URL for the content to get as a string
     * @param cancellable a {@link GLib.Cancellable}
     *
     * @return the content at the URL as a string
     *
     * @throws GLib.Error if an error occurs while downloading the content
     */
    public static string get_as_string (string url, GLib.Cancellable? cancellable = null) throws GLib.Error {
        var session = new Soup.Session ();
        var message = new Soup.Message.from_uri (HTTP_GET, GLib.Uri.parse (url, GLib.UriFlags.NONE));
        var input_stream = new DataInputStream (session.send (message, cancellable));
        var sb = new GLib.StringBuilder ();
        string? line;
        while ((line = input_stream.read_line ()) != null) {
            sb.append (line);
        }
        return sb.str;
    }

    /**
     * Returns whether or not the given HTTP status code indicates an error
     * on either the client or the server side.
     *
     * @param status_code the HTTP status code
     * @return //true// if the status codes indicates an error, otherwise //false//
     */
    public static bool is_error (uint status_code) {
        return is_client_error (status_code) || is_server_error (status_code);
    }

    /**
     * Returns whether or not the given HTTP status code indicates an error
     * on on the client side (i.e. 4xx).
     *
     * @param status_code the HTTP status code
     * @return //true// if the status codes indicates a client-side error, otherwise //false//
     */
    public static bool is_client_error (uint status_code) {
        return status_code >= 400 && status_code <= 499;
    }

    /**
     * Returns whether or not the given HTTP status code indicates an error
     * on on the server side (i.e. 5xx).
     *
     * @param status_code the HTTP status code
     * @return //true// if the status codes indicates a server-side error, otherwise //false//
     */
    public static bool is_server_error (uint status_code) {
        return status_code >= 500 && status_code <= 599;
    }

    /**
     * Returns whether or not the given port number is valid.
     *
     * @param port_number the port number to validate
     * @return //true// if the given port number is valid, otherwise //false//
     */
    public static bool validate_port (uint port_number) {
        return port_number >= Catalyst.Http.MIN_PORT && port_number <= Catalyst.Http.MAX_PORT;
    }

    /**
     * Returns a valid, random port number equally distrubted over the range provided
     * by the lower and upper bounds.
     *
     * @param lower_bound the lower bound (inclusive) for obtaining the port number
     * @param upper_bound the upper bound (inclusive) for obtaining the port number
     * @return A new valid, random port number
     */
    public static uint random_port (uint lower_bound = Catalyst.Http.MIN_PORT,
            uint upper_bound = Catalyst.Http.MAX_PORT) {
        return (uint) GLib.Random.int_range ((int32) lower_bound, (int32) upper_bound + 1);
    }

    /**
     * Returns a valid, random port number equally distrubted over the range.
     *
     * @param port_range the {@link Catalyst.Http.PortRange}
     * @return A new valid, random port number for the given port range
     */
    public static uint random_port_for_range (Catalyst.Http.PortRange port_range) {
        return (uint) GLib.Random.int_range ((int32) port_range.get_minimum_port (),
            (int32) port_range.get_maximum_port () + 1);
    }

}
