/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.ByteUtilsTest : GLib.Object {

    private static void test () {
        char byte = 0x01;
        assert_true (Catalyst.ByteUtils.get_bit (byte, 0));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 1));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 2));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 3));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 4));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 5));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 6));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 7));

        byte = Catalyst.ByteUtils.set_bit (byte, 3);
        assert_true (Catalyst.ByteUtils.get_bit (byte, 0));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 1));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 2));
        assert_true (Catalyst.ByteUtils.get_bit (byte, 3));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 4));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 5));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 6));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 7));

        byte = Catalyst.ByteUtils.clear_bit (byte, 0);
        assert_false (Catalyst.ByteUtils.get_bit (byte, 0));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 1));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 2));
        assert_true (Catalyst.ByteUtils.get_bit (byte, 3));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 4));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 5));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 6));
        assert_false (Catalyst.ByteUtils.get_bit (byte, 7));
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/byte_utils", test);
        GLib.Test.run ();
    }

}
