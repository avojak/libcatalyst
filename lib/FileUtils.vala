/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * The FileUtils namespace contains useful functions for handling files.
 */
namespace Catalyst.FileUtils {

    /**
     * Determines the extension for the given file.
     *
     * @param file the file for which to get the extension
     * @param normalize if the returned string should be normalized (i.e. case-converted down)
     *
     * @return the file extension string, or null if the file does not exist, or there is no file extension
     */
    public static string? get_extension (GLib.File file, bool normalize = true) {
        string? path = file.get_path ();
        if (path == null) {
            return null;
        }
        int last_separator = path.last_index_of (".");
        if (last_separator == -1) {
            return null;
        }
        var extension = path.substring (last_separator + 1);
        return normalize ? extension.down () : extension;
    }

    /**
     * Performs a recursive copy from src to dest.
     * 
     * @param src the file/folder to recursively copy
     * @param dest the target file/folder that will be created as a result of the copy
     * @param flags the {@link GLib.FileCopyFlags}
     * @param cancellable a {@link GLib.Cancellable}
     *
     * @throws GLib.Error if an error occurs while copying the directory
     */
    public static void copy_recursive (GLib.File src, GLib.File dest,
            GLib.FileCopyFlags flags = GLib.FileCopyFlags.NONE,
            GLib.Cancellable? cancellable = null) throws GLib.Error {
        GLib.FileType src_type = src.query_file_type (GLib.FileQueryInfoFlags.NONE, cancellable);
        if (src_type == GLib.FileType.DIRECTORY) {
            dest.make_directory (cancellable);
            src.copy_attributes (dest, flags, cancellable);
            GLib.FileEnumerator enumerator = src.enumerate_children (
                GLib.FileAttribute.STANDARD_NAME,
                GLib.FileQueryInfoFlags.NONE,
                cancellable);
            for (GLib.FileInfo? info = enumerator.next_file (cancellable);
                    info != null;
                    info = enumerator.next_file (cancellable)) {
                copy_recursive (
                    GLib.File.new_for_path (GLib.Path.build_filename (src.get_path (), info.get_name ())),
                    GLib.File.new_for_path (GLib.Path.build_filename (dest.get_path (), info.get_name ())),
                    flags,
                    cancellable);
            }
        } else if (src_type == GLib.FileType.REGULAR) {
            src.copy (dest, flags, cancellable);
        }
    }

    /**
     * Performs a recursive delete of the given directory. If the given file is not a directory,
     * but is a regular file, it will behave the same as {@link GLib.File.delete}.
     * 
     * @param file the file/folder to recursively delete
     * @param cancellable a {@link GLib.Cancellable}
     *
     * @throws GLib.Error if an error occurs while deleting the file/directory
     */
    public static void delete_recursive (GLib.File file, GLib.Cancellable? cancellable = null) throws GLib.Error {
        GLib.FileType file_type = file.query_file_type (GLib.FileQueryInfoFlags.NONE, cancellable);
        if (file_type == GLib.FileType.DIRECTORY) {
            GLib.FileEnumerator enumerator = file.enumerate_children (
                GLib.FileAttribute.STANDARD_NAME,
                GLib.FileQueryInfoFlags.NONE,
                cancellable);
            for (GLib.FileInfo? info = enumerator.next_file (cancellable);
                    info != null;
                    info = enumerator.next_file (cancellable)) {
                delete_recursive (
                    GLib.File.new_for_path (GLib.Path.build_filename (file.get_path (), info.get_name ())),
                    cancellable);
            }
            file.delete (cancellable);
        } else if (file_type == GLib.FileType.REGULAR) {
            file.delete (cancellable);
        }
    }

    /**
     * Extracts an archive file.
     * 
     * @param archive_file the archive file to extract
     * @param target the {@link GLib.File} which will be created as a result
     *
     * @return Whether or not the archive was successfully extracted
     */
    public static bool extract_archive (GLib.File archive_file, GLib.File target) {
        Archive.ExtractFlags flags;
        flags = Archive.ExtractFlags.TIME;
        flags |= Archive.ExtractFlags.PERM;
        flags |= Archive.ExtractFlags.ACL;
        flags |= Archive.ExtractFlags.FFLAGS;

        Archive.Read archive = new Archive.Read ();
        archive.support_format_all ();
        archive.support_filter_all ();

        Archive.WriteDisk extractor = new Archive.WriteDisk ();
        extractor.set_options (flags);
        extractor.set_standard_lookup ();

        if (archive.open_filename (archive_file.get_path (), 10240) != Archive.Result.OK) {
            warning ("Error opening %s: %s (%d)", archive_file.get_path (), archive.error_string (), archive.errno ());
            return false;
        }

        unowned Archive.Entry entry;
        Archive.Result last_result;
        while ((last_result = archive.next_header (out entry)) == Archive.Result.OK) {
            entry.set_pathname (GLib.Path.build_filename (archive_file.get_parent ().get_path (), entry.pathname ()));
            if (extractor.write_header (entry) != Archive.Result.OK) {
                continue;
            }
            uint8[] buffer;
            Archive.int64_t offset;
            while (archive.read_data_block (out buffer, out offset) == Archive.Result.OK) {
                if (extractor.write_data_block (buffer, offset) != Archive.Result.OK) {
                    break;
                }
            }
        }

        if (last_result != Archive.Result.EOF) {
            warning ("Error extracting archive: %s (%d)", archive.error_string (), archive.errno ());
            return false;
        }

        return true;
    }

}
