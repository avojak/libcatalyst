/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * The ByteUtils namespace contains useful functions for operating on byte values.
 */
namespace Catalyst.ByteUtils {

    /**
     * Gets the bit value at the given position within the byte.
     *
     * @param byte_value the byte
     * @param position the position in the byte to retrieve the bit value
     * @return the bit value at the given position within the byte
     */
    public static bool get_bit (char byte_value, size_t position) {
        assert (position >= 0 && position <= 7);
        return (byte_value & (1 << position)) != 0;
    }

    /**
     * Sets the bit value at the given position within the byte.
     * This has the effect of setting the bit value to 1.
     *
     * @param byte_value the byte
     * @param position the position in the byte to set the bit value
     * @return the new byte value
     */
    public static char set_bit (char byte_value, size_t position) {
        assert (position >= 0 && position <= 7);
        return byte_value | (1 << position);
    }

    /**
     * Clears the bit value at the given position within the byte.
     * This has the effect of setting the bit value to 0.
     *
     * @param byte_value the byte
     * @param position the position in the byte to clear the bit
     * @return the new byte value
     */
    public static char clear_bit (char byte_value, size_t position) {
        assert (position >= 0 && position <= 7);
        return byte_value & ~(1 << position);
    }

}
