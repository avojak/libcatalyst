/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/** 
 * Models the context of the download, including the URL, and target output file.
 * Provides the ability to monitor the progress of the download via signals.
 */
public class Catalyst.DownloadContext : GLib.Object {

    public string url { get; construct; }
    public GLib.File output_file { get; construct; }

    public DownloadContext (string url, GLib.File output_file) {
        Object (
            url: url,
            output_file: output_file
        );
    }

    /**
     * The download is complete.
     */
    public signal void complete ();

    /**
     * The download failed.
     *
     * @param message an optional message describing the failure
     * @param status_code the HTTP status code of the response, if available
     */
    public signal void failed (string? message, uint? status_code = null);

    /**
     * There has been progress made during the download. When this signal is received,
     * the number of bytes read will have changed, and the user can recompute overall
     * progress if the total number of bytes is known.
     */
    public signal void progress (int64 bytes_read, int64 total_bytes);

}
