/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.HttpTest : GLib.Object {

    private static void test_constants () {
        assert_true (0 == Catalyst.Http.MIN_PORT);
        assert_true (65535 == Catalyst.Http.MAX_PORT);
    }

    private static void test_well_known_port_range () {
        assert_true (0 == Catalyst.Http.PortRange.WELL_KNOWN.get_minimum_port ());
        assert_true (1023 == Catalyst.Http.PortRange.WELL_KNOWN.get_maximum_port ());
        for (uint port = Catalyst.Http.PortRange.WELL_KNOWN.get_minimum_port ();
                port <= Catalyst.Http.PortRange.WELL_KNOWN.get_maximum_port ();
                port++) {
            assert_true (Catalyst.Http.PortRange.WELL_KNOWN.validate_port (port));
        }
    }

    private static void test_registered_port_range () {
        assert_true (1024 == Catalyst.Http.PortRange.REGISTERED.get_minimum_port ());
        assert_true (49151 == Catalyst.Http.PortRange.REGISTERED.get_maximum_port ());
        for (uint port = Catalyst.Http.PortRange.REGISTERED.get_minimum_port ();
                port <= Catalyst.Http.PortRange.REGISTERED.get_maximum_port ();
                port++) {
            assert_true (Catalyst.Http.PortRange.REGISTERED.validate_port (port));
        }
    }

    private static void test_dynamic_port_range () {
        assert_true (49152 == Catalyst.Http.PortRange.DYNAMIC.get_minimum_port ());
        assert_true (65535 == Catalyst.Http.PortRange.DYNAMIC.get_maximum_port ());
        for (uint port = Catalyst.Http.PortRange.DYNAMIC.get_minimum_port ();
                port <= Catalyst.Http.PortRange.DYNAMIC.get_maximum_port ();
                port++) {
            assert_true (Catalyst.Http.PortRange.DYNAMIC.validate_port (port));
        }
    }

    public static void main (string[] args) {
        GLib.Test.init (ref args);
        GLib.Test.add_func ("/http/constants", test_constants);
        GLib.Test.add_func ("/http/port_range/well_known", test_well_known_port_range);
        GLib.Test.add_func ("/http/port_range/registered", test_registered_port_range);
        GLib.Test.add_func ("/http/port_range/dynamic", test_dynamic_port_range);
        GLib.Test.run ();
    }

}
