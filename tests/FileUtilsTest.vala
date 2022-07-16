/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.FileUtilsTest : GLib.Object {

    private static void test_get_extension () {
        assert_null (Catalyst.FileUtils.get_extension (GLib.File.new_for_path ("/fakenotreal")));

        var file = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "sample.txt"));
        assert_true ("txt" == Catalyst.FileUtils.get_extension (file));

        file = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "some.folder", "SAMPLE.TXT"));
        assert_true ("txt" == Catalyst.FileUtils.get_extension (file));
        assert_true ("TXT" == Catalyst.FileUtils.get_extension (file, false));

        file = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "some.folder", "sample"));
        assert_null (Catalyst.FileUtils.get_extension (file));
    }

    private static void test_list_files () {
        var file1 = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "sample.txt"));
        var file2 = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "some.folder", "SAMPLE.TXT"));
        var file3 = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "some.folder", "sample"));

        var dir = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data"));
        try {
            var files = new Gee.HashSet<GLib.File> ((f) => {
                return f.hash ();
            }, (a, b) => {
                return a.get_path () == b.get_path ();
            });
            files.add_all (Catalyst.FileUtils.list_files (dir));
            assert_true (3 == files.size);
            assert_true (files.contains (file1));
            assert_true (files.contains (file2));
            assert_true (files.contains (file3));
        } catch (GLib.Error e) {
            GLib.Test.fail ();
        }

        try {
            var files = new Gee.HashSet<GLib.File> ((f) => {
                return f.hash ();
            }, (a, b) => {
                return a.get_path () == b.get_path ();
            });
            files.add_all (Catalyst.FileUtils.list_files (dir, false));
            assert_true (1 == files.size);
            assert_true (files.contains (file1));
            assert_false (files.contains (file2));
            assert_false (files.contains (file3));
        } catch (GLib.Error e) {
            GLib.Test.fail ();
        }
        
        try {
            var file = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "sample.txt"));
            assert_null (Catalyst.FileUtils.list_files (file));
        } catch (GLib.Error e) {
            GLib.Test.fail ();
        }
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/file_utils/get_extension", test_get_extension);
        GLib.Test.add_func ("/file_utils/list_files", test_list_files);
        GLib.Test.run ();
    }

}
