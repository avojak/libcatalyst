/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * The EnumUtils namespace contains useful functions for operating on enums.
 */
namespace Catalyst.EnumUtils {

    /**
     * Retrieves the enum value for the given string name. The string name is the value
     * obtained when calling //to_string ()// on an enum value.
     *
     * {{{
     * // Result: ``true``
     * MyEnum.FOO == Catalyst.EnumUtils.get_value_by_name<MyEnum> (MyEnum.FOO.to_string ());
     * }}}
     *
     * It is an assertion error to provide a non-enum class as the type argument.
     *
     * @param name the string name value
     * @return the enum value
     *
     * @throws Catalyst.EnumParseError if no enum value exists with the given name
     */
    public static T get_value_by_name<T> (string name) throws Catalyst.EnumParseError {
        assert (typeof (T).is_enum ());
        EnumClass enumc = (EnumClass) typeof (T).class_ref ();
        unowned EnumValue? eval = enumc.get_value_by_name (name);
        if (eval == null) {
            throw new Catalyst.EnumParseError.INVALID_NAME (@"No enum value exists for the name: \"$name\"");
        }
        return (T) eval.value;
    }

    /**
     * Retrieves the enum value for the given string nick.
     *
     * It is an assertion error to provide a non-enum class as the type argument.
     *
     * @param nick the string nick value
     * @return the enum value
     *
     * @throws Catalyst.EnumParseError if no enum value exists with the given nick
     */
    public static T get_value_by_nick<T> (string nick) throws Catalyst.EnumParseError {
        assert (typeof (T).is_enum ());
        EnumClass enumc = (EnumClass) typeof (T).class_ref ();
        unowned EnumValue? eval = enumc.get_value_by_nick (nick);
        if (eval == null) {
            throw new Catalyst.EnumParseError.INVALID_NICK (@"No enum value exists for the nick: \"$nick\"");
        }
        return (T) eval.value;
    }

    /**
     * Retrieves all the values in the enum as an array.
     *
     * @return A new array containing all the values contained in the enum.
     */
    public static T[] get_values<T> () {
        assert (typeof (T).is_enum ());
        EnumClass enumc = (EnumClass) typeof (T).class_ref ();
        int[] values = new int[enumc.n_values];
        int i = 0;
        foreach (unowned EnumValue enum_value in enumc.values) {
            values[i] = enum_value.@value;
            i++;
        }
        return (T[]) values;
    }

}
