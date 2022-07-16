/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.HttpUtilsTest : GLib.Object {

    private static void test_error_code () {
        for (uint status_code = 400; status_code <= 599; status_code++) {
            assert_true (HttpUtils.is_error (status_code));
        }
        for (uint status_code = 200; status_code <= 299; status_code++) {
            assert_false (HttpUtils.is_error (status_code));
        }
    }

    private static void test_client_error_code () {
        for (uint status_code = 400; status_code <= 499; status_code++) {
            assert_true (HttpUtils.is_client_error (status_code));
        }
    }

    private static void test_server_error_code () {
        for (uint status_code = 500; status_code <= 599; status_code++) {
            assert_true (HttpUtils.is_server_error (status_code));
        }
    }

    private static void test_validate_port () {
        for (uint port = Catalyst.Http.MIN_PORT; port <= Catalyst.Http.MAX_PORT; port++) {
            assert_true (HttpUtils.validate_port (port));
        }
        assert_false (HttpUtils.validate_port (65536));
    }

    private static void test_random_port () {
        assert_true (HttpUtils.validate_port (HttpUtils.random_port ()));
    }

    private static void test_random_port_for_range () {
        validate_random_port_for_range (Catalyst.Http.PortRange.WELL_KNOWN);
        validate_random_port_for_range (Catalyst.Http.PortRange.REGISTERED);
        validate_random_port_for_range (Catalyst.Http.PortRange.DYNAMIC);
    }

    private static void validate_random_port_for_range (Catalyst.Http.PortRange port_range) {
        assert_true (port_range.validate_port (HttpUtils.random_port_for_range (port_range)));
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/http_utils/error_code", test_error_code);
        GLib.Test.add_func ("/http_utils/client_error_code", test_client_error_code);
        GLib.Test.add_func ("/http_utils/server_error_code", test_server_error_code);
        GLib.Test.add_func ("/http_utils/validate_port", test_validate_port);
        GLib.Test.add_func ("/http_utils/random_port", test_random_port);
        GLib.Test.add_func ("/http_utils/random_port_for_range", test_random_port_for_range);
        GLib.Test.run ();
    }

}
