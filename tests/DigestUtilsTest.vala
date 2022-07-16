/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.DigestUtilsTest : GLib.Object {

    private static void test_md5_digest () {
        test_digest ("6cd3556deb0da54bca060b4c39479839", GLib.ChecksumType.MD5);
    }

    private static void test_sha1_digest () {
        test_digest ("943a702d06f34599aee1f8da8ef9f7296031d699", GLib.ChecksumType.SHA1);
    }

    private static void test_sha256_digest () {
        test_digest ("315f5bdb76d078c43b8ac0064e4a0164612b1fce77c869345bfc94c75894edd3", GLib.ChecksumType.SHA256);
    }

    private static void test_sha384_digest () {
        test_digest ("55bc556b0d2fe0fce582ba5fe07baafff035653638c7ac0d5494c2a64c0bea1cc57331c7c12a45cdbca7f4c34a089eeb", GLib.ChecksumType.SHA384); //vala-lint=line-length
    }

    private static void test_sha512_digest () {
        test_digest ("c1527cd893c124773d811911970c8fe6e857d6df5dc9226bd8a160614c0cd963a4ddea2b94bb7d36021ef9d865d5cea294a82dd49a0bb269f51f6e7a57f79421", GLib.ChecksumType.SHA512); //vala-lint=line-length
    }

    private static void test_digest (string expected_digest, GLib.ChecksumType checksum_type) {
        var file = GLib.File.new_for_path (GLib.Test.get_filename (GLib.Test.FileType.DIST, "data", "sample.txt"));
        try {
            assert_true (expected_digest == Catalyst.DigestUtils.compute_for_file (checksum_type, file));
            assert_false ("fakenotreal" == Catalyst.DigestUtils.compute_for_file (checksum_type, file));
        } catch (GLib.Error e) {
            warning ("Unexpected error: %s", e.message);
            GLib.Test.fail ();
        }
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/digest_utils/md5", test_md5_digest);
        GLib.Test.add_func ("/digest_utils/sha1", test_sha1_digest);
        GLib.Test.add_func ("/digest_utils/sha256", test_sha256_digest);
        GLib.Test.add_func ("/digest_utils/sha384", test_sha384_digest);
        GLib.Test.add_func ("/digest_utils/sha512", test_sha512_digest);
        GLib.Test.run ();
    }

}
