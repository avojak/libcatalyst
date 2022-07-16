/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

namespace Catalyst {

    public errordomain BigIntegerParseError {
        /**
         * Invalid string value
         */
        INVALID_VALUE;
    }

    /**
     * Models an arbitrarily-large (positive or negative) integer value.
     */
    public class BigInteger : GLib.Object {

        private const string REGEX_STR = """^([-]?[1-9]\d*|0)$""";

        private static GLib.Regex regex;

        public string value { get; private set; }

        static construct {
            try {
                regex = new GLib.Regex (REGEX_STR, GLib.RegexCompileFlags.OPTIMIZE);
            } catch (GLib.RegexError e) {
                critical ("Error while constructing regex: %s", e.message);
            }
        }

        private BigInteger (string value) {
            this.value = value;
        }

        public BigInteger.from_string (string str) throws BigIntegerParseError {
            if (!regex.match (str, GLib.RegexMatchFlags.ANCHORED)) {
                throw new BigIntegerParseError.INVALID_VALUE ("Invalid BigInteger string: \"%s\"".printf (str));
            }
            this.value = str;
        }

        /**
         * Adds this value to another value.
         *
         * @param other the other {@link BigInteger}
         * @return a new {@link BigInteger} representing the result of the addition
         */
        public BigInteger add (BigInteger other) {
            // Determine the maximum possible length of the resulting string, accounting for potential carry
            int max_len = (this.value.length > other.value.length ? this.value.length : other.value.length) + 1;

            // Pad each string and convert to the array of parts
            uint8[] this_parts = (string.nfill (max_len - this.value.length, '0') + this.value).data;
            uint8[] other_parts = (string.nfill (max_len - other.value.length, '0') + other.value).data;
            // Create the result char array
            uint8[] result = string.nfill (max_len, '0').data;

            // Iterate over all parts, initially there is no value to carry
            int carry = 0;
            for (int i = max_len - 1; i >= 0; i--) {
                // Perform addition on the parsed parts. We can safely do normal integer addition here because the
                // maximum values are very small (no more than 9+9+1 if there is a carry).
                int intermediate = int.parse (((char) this_parts[i]).to_string ())
                        + int.parse (((char) other_parts[i]).to_string ())
                        + carry;
                // If the intermediate value is greater than 9 (i.e. double-digit), set the carry value and add the
                // least significant digit to the result array.
                if (intermediate > 9) {
                    result[i] = intermediate.to_string ().data[1];
                    carry = 1;
                } else {
                    result[i] = intermediate.to_string ().data[0];
                    carry = 0;
                }
            }

            // Remove the leading 0 if no value was carried into its place
            int offset = (char) result[0] == '0' ? 1 : 0;
            return new BigInteger (((string) result).substring (offset, max_len - offset));
        }

        /**
         * Subtracts another value from this value.
         *
         * @param other the other {@link BigInteger}
         * @return a new {@link BigInteger} representing the result of the subtraction
         */
        public BigInteger subtract (BigInteger other) {
            // If a is less than b, flip the subtraction so we end up with a positive result, then flip the sign at the end
            if (this.compare_to (other) < 0) {
                var intermediate = other.subtract (this).value;
                return new BigInteger (@"-$intermediate");
            }
            // Determine the maximum possible length of the resulting string, including space for a possible negative sign
            int max_len = (this.value.length > other.value.length ? this.value.length : other.value.length) + 1;

            // Pad each string and convert to the array of parts
            uint8[] this_parts = (string.nfill (max_len - this.value.length, '0') + this.value).data;
            uint8[] other_parts = (string.nfill (max_len - other.value.length, '0') + other.value).data;
            // Create the result char array
            uint8[] result_chars = string.nfill (max_len, '0').data;

            // Iterate over all parts, initially there is no value to carry
            int carry = 0;
            for (int i = max_len - 1; i >= 0; i--) {
                // Perform subtraction on the parsed parts. We can safely do normal integer subtraction here because the
                // maximum values are very small.
                int this_part_numeric = int.parse (((char) this_parts[i]).to_string ());
                int other_part_numeric = int.parse (((char) other_parts[i]).to_string ());
                int intermediate = this_part_numeric - other_part_numeric - carry;

                // If the intermediate value is negative, redo the subtraction with the carried value and add the
                // least significant digit to the result array. Update carry value.
                if (intermediate < 0) {
                    intermediate = (this_part_numeric + 10) - other_part_numeric - carry;
                    result_chars[i] = (-1 * intermediate).to_string ().data[1];
                    carry = 1;
                } else {
                    result_chars[i] = intermediate.to_string ().data[0];
                    carry = 0;
                }
            }

            string result = ((string) result_chars).substring (0, max_len);
            // Remove the leading zeroes
            while (result.has_prefix ("0") && result.length > 1) {
                result = result.substring (1);
            }
            return new BigInteger (result);
        }

        /**
         * Compares this value to another value.
         *
         * @param other the other {@link BigInteger}
         * @return -1, 0, or 1 if this value is less than, equal to, or greater than the other value
         */
        public int compare_to (BigInteger other) {
            // First check for different signs
            if (this.value.has_prefix ("-") && !other.value.has_prefix ("-")) {
                return -1;
            }
            if (!this.value.has_prefix ("-") && other.value.has_prefix ("-")) {
                return 1;
            }

            // We know both numbers have the same sign now
            bool both_negative = this.value.has_prefix ("-") && other.value.has_prefix ("-");

            // Next check length, accounting for signs
            if (this.value.length < other.value.length) {
                if (both_negative) {
                    return 1;
                } else {
                    return -1;
                }
            }
            if (this.value.length > other.value.length) {
                if (both_negative) {
                    return -1;
                } else {
                    return 1;
                }
            }

            // Both numbers are the same sign and the same length, so we begin comparing for differences
            for (int i = 0; i < this.value.length; i++) {
                int this_numeric = int.parse (((char) this.value.data[i]).to_string ());
                int other_numeric = int.parse (((char) other.value.data[i]).to_string ());
                if (this_numeric == other_numeric) {
                    continue;
                }
                var result = ((int) (this_numeric > other_numeric) - (int) (this_numeric < other_numeric));
                // Comparison should be flipped for two negative values
                if (both_negative) {
                    result = -result;
                }
                return result;
            }
            return 0;
        }

    }

}
