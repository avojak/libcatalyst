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
     * @param context a {@link Catalyst.DownloadContext} providing request details as well as a means of tracking
     *      progress and signaling completion/failure
     * @param cancellable a {@link GLib.Cancellable}
     */
    public static void download_file_sync (Catalyst.DownloadContext context, GLib.Cancellable? cancellable = null) {
        // Create the session
        var session = new Soup.Session () {
            use_thread_context = true
        };
        var uri = new Soup.URI (context.url);
        if (uri == null) {
            context.failed ("Invalid URI: %s".printf (context.url));
            return;
        }

        // Send the request and obtain the input stream
        var message = new Soup.Message.from_uri (HTTP_GET, new Soup.URI (context.url));
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
     * @param context a {@link Catalyst.DownloadContext} providing request details as well as a means of tracking
     *      progress and signaling completion/failure
     * @param cancellable a {@link GLib.Cancellable}
     */
    public static async void download_file_async (Catalyst.DownloadContext context,
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
        var session = new Soup.Session () {
            use_thread_context = true
        };
        var input_stream = new DataInputStream (session.request (url).send ());
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
     * @return true if the status codes indicates an error, otherwise false
     */
    public static bool is_error (uint status_code) {
        return is_client_error (status_code) || is_server_error (status_code);
    }

    /**
     * Returns whether or not the given HTTP status code indicates an error
     * on on the client side (i.e. 4xx).
     *
     * @param status_code the HTTP status code
     * @return true if the status codes indicates a client-side error, otherwise false
     */
    public static bool is_client_error (uint status_code) {
        return status_code >= 400 && status_code <= 499;
    }

    /**
     * Returns whether or not the given HTTP status code indicates an error
     * on on the server side (i.e. 5xx).
     *
     * @param status_code the HTTP status code
     * @return true if the status codes indicates a server-side error, otherwise false
     */
    public static bool is_server_error (uint status_code) {
        return status_code >= 500 && status_code <= 599;
    }

}
