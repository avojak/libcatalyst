/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.OptionalTest : GLib.Object {

    private static void test_optional () {
        var optional = new Optional<string>.of ("hello");
        assert_true (optional.value == "hello");
        assert_true (optional.is_present);

        optional = new Optional<string>.empty ();
        assert_false (optional.is_present);
        assert_true (optional.or_else ("world") == "world");
        assert_true (optional.or_else_get (() => {
            return "world";
        }) == "world");

        string? str = null;
        optional = new Optional<string>.of_nullable (str);
        assert_false (optional.is_present);
        assert_true (optional.or_else ("world") == "world");
        assert_true (optional.or_else_get (() => {
            return "world";
        }) == "world");
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/optional", test_optional);
        GLib.Test.run ();
    }

}
