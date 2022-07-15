/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * The DigestUtils namespace contains useful functions for computing checksums.
 */
namespace Catalyst.DigestUtils {

    private const int BUFFER_SIZE = 256;

    /**
     * Computes the checksum for a file.
     * 
     * @param checksum_type a {@link GLib.ChecksumType}
     * @param file the {@link GLib.File} to compute the digest of
     *
     * @return the checksum as a string
     *
     * @throws GLib.Error if there was an error computing the checksum
     */
    public static string compute_for_file (GLib.ChecksumType checksum_type, GLib.File file) throws GLib.Error {
                GLib.Checksum checksum = new GLib.Checksum (checksum_type);
        uint8 buffer[BUFFER_SIZE];
        size_t bytes_read;
        GLib.FileInputStream stream = file.read ();
        while ((bytes_read = stream.read (buffer)) > 0) {
            checksum.update (buffer, bytes_read);
        }
        return checksum.get_string ();
    }

}
