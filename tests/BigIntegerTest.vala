/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.BigIntegerTest : GLib.Object {

    private static void test_parse () {
        try {
            new Catalyst.BigInteger.from_string ("2147483647");
            new Catalyst.BigInteger.from_string ("-2147483647");
            new Catalyst.BigInteger.from_string ("1");
            new Catalyst.BigInteger.from_string ("0");
            new Catalyst.BigInteger.from_string ("999999999999999999999999");
            new Catalyst.BigInteger.from_string ("-999999999999999999999999");
            new Catalyst.BigInteger.from_string ("184467440737095516150");
        } catch (Catalyst.BigIntegerParseError e) {
            GLib.Test.fail ();
        }
    }

    private static void test_add () {
        try {
            var a = new Catalyst.BigInteger.from_string ("184467440737095516150");
            var b = new Catalyst.BigInteger.from_string ("987089102934719827394");
            assert_true ("1171556543671815343544" == a.add (b).value);
        } catch (Catalyst.BigIntegerParseError e) {
            GLib.Test.fail ();
        }
    }

    private static void test_subtract () {
        try {
            var a = new Catalyst.BigInteger.from_string ("1171556543671815343544");
            var b = new Catalyst.BigInteger.from_string ("987089102934719827394");
            assert_true ("184467440737095516150" == a.subtract (b).value);
        } catch (Catalyst.BigIntegerParseError e) {
            GLib.Test.fail ();
        }
    }

    private static void test_compare () {
        try {
            var a = new Catalyst.BigInteger.from_string ("987089102934719827394");
            var b = new Catalyst.BigInteger.from_string ("184467440737095516150");
            assert_true (a.compare_to (b) == 1);
            assert_true (b.compare_to (a) == -1);
            assert_true (a.compare_to (a) == 0);

            a = new Catalyst.BigInteger.from_string ("184467440737095516150");
            b = new Catalyst.BigInteger.from_string ("-987089102934719827394");
            assert_true (a.compare_to (b) == 1);
            assert_true (b.compare_to (a) == -1);
            assert_true (a.compare_to (a) == 0);

            a = new Catalyst.BigInteger.from_string ("-987089102934719827394");
            b = new Catalyst.BigInteger.from_string ("-184467440737095516150");
            assert_true (a.compare_to (b) == -1);
            assert_true (b.compare_to (a) == 1);
            assert_true (a.compare_to (a) == 0);
        } catch (Catalyst.BigIntegerParseError e) {
            GLib.Test.fail ();
        }
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/big_integer/parse", test_parse);
        GLib.Test.add_func ("/big_integer/add", test_add);
        GLib.Test.add_func ("/big_integer/subtract", test_subtract);
        GLib.Test.add_func ("/big_integer/compare", test_compare);
        GLib.Test.run ();
    }

}
