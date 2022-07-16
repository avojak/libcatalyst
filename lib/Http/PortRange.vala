/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * Models the port ranges.
 */
public enum Catalyst.Http.PortRange {
    /**
     * "Well Known" (i.e. "system") ports.
     */
    WELL_KNOWN,
    /**
     * "Registered" (i.e. "user") ports.
     */
    REGISTERED,
    /**
     * "Dynamic" (i.e. "private") ports.
     */
    DYNAMIC;

    /**
     * Gets the minimum valid port number for the range.
     */
    public uint get_minimum_port () {
        switch (this) {
            case WELL_KNOWN:
                return 0x0000; // 0
            case REGISTERED:
                return 0x0400; // 1024
            case DYNAMIC:
                return 0xC000; // 49152
            default:
                assert_not_reached ();
        }
    }

    /**
     * Gets the maximum valid port number for the range.
     */
    public uint get_maximum_port () {
        switch (this) {
            case WELL_KNOWN:
                return 0x03FF; // 1023
            case REGISTERED:
                return 0xBFFF; // 49151
            case DYNAMIC:
                return 0xFFFF; // 65535
            default:
                assert_not_reached ();
        }
    }

    /**
     * Returns whether or not the given port number is valid
     * for the range.
     *
     * @return true if the port is valid for the range, otherwise false
     */
    public bool validate_port (uint port) {
        return port >= get_minimum_port () && port <= get_maximum_port ();
    }
}
