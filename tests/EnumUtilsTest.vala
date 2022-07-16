/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.EnumUtilsTest : GLib.Object {

    private enum Enum {
        A = 0, B = 5, C = 6;
    }

    private static void test_get_value_by_name_valid () {
        try {
            assert_true (Enum.A == Catalyst.EnumUtils.get_value_by_name<Enum> (Enum.A.to_string ()));
            assert_true (Enum.B == Catalyst.EnumUtils.get_value_by_name<Enum> (Enum.B.to_string ()));
            assert_true (Enum.C == Catalyst.EnumUtils.get_value_by_name<Enum> (Enum.C.to_string ()));
        } catch (Catalyst.EnumParseError e) {
            GLib.Test.fail ();
        }
    }

    private static void test_get_value_by_name_invalid () {
        try {
            Catalyst.EnumUtils.get_value_by_name<Enum> ("FAKE_NOT_REAL");
        } catch (Catalyst.EnumParseError e) {
            // Expected
            return;
        }
        GLib.Test.fail ();
    }

    private static void test_get_value_by_nick_valid () {
        try {
            assert_true (Enum.A == Catalyst.EnumUtils.get_value_by_nick<Enum> ("a"));
            assert_true (Enum.B == Catalyst.EnumUtils.get_value_by_nick<Enum> ("b"));
            assert_true (Enum.C == Catalyst.EnumUtils.get_value_by_nick<Enum> ("c"));
        } catch (Catalyst.EnumParseError e) {
            GLib.Test.fail ();
        }
    }

    private static void test_get_value_by_nick_invalid () {
        try {
            Catalyst.EnumUtils.get_value_by_nick<Enum> ("FAKE_NOT_REAL");
        } catch (Catalyst.EnumParseError e) {
            // Expected
            return;
        }
        GLib.Test.fail ();
    }

    private static void test_get_values () {
        var values = Catalyst.EnumUtils.get_values<Enum> ();
        assert_true (3 == values.length);
        assert_true (Enum.A == values[0]);
        assert_true (Enum.B == values[1]);
        assert_true (Enum.C == values[2]);
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/enum_utils/get_value_by_name/valid", test_get_value_by_name_valid);
        GLib.Test.add_func ("/enum_utils/get_value_by_name/invalid", test_get_value_by_name_invalid);
        GLib.Test.add_func ("/enum_utils/get_value_by_nick/valid", test_get_value_by_nick_valid);
        GLib.Test.add_func ("/enum_utils/get_value_by_nick/invalid", test_get_value_by_nick_invalid);
        GLib.Test.add_func ("/enum_utils/get_values", test_get_values);
        GLib.Test.run ();
    }

}
