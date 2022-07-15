/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

/**
 * A container object which may or may not contain a non-null value.
 */
public class Catalyst.Optional<T> : GLib.Object {

    private T? _value = null;

    /**
     * The value held by the optional.
     *
     * If the value is present, it will be returned. Otherwise,
     * the assertion fails.
     */
    public T value {
        get {
            assert_nonnull (_value);
            return _value;
        }
    }

    /**
     * Whether or not the the optional contains a value.
     */
    public bool is_present {
        get {
            return _value != null;
        }
    }

    private Optional () { /* Disallowed */ }

    /**
     * Creates an optional from a non-null value. It is
     * an assertion failure to provide a null value.
     *
     * @param value The non-null value.
     */
    public Optional.of (owned T value) {
        assert_nonnull (value);
        this._value = (owned) value;
    }

    /**
     * Creates an optional from a potentially null value.
     * If the provided value is null, the optional will be empty.
     * 
     * @param value The potentially null value.
     */
    public Optional.of_nullable (owned T? value) {
        if (value != null) {
            this._value = (owned) value;
        }
    }

    /**
     * Creates an empty instance.
     */
    public Optional.empty () {
    }

    /**
     * Filters the value based on the given predicate.
     *
     * @param predicate The predicate function.
     * @return If the value is present and matches the predicate, an Optional
     * containing the value is returned. Otherwise, returns an empty Optional.
     */
    public Optional<T> filter (Gee.Predicate<T> predicate) {
        if (is_present) {
            return predicate (value) ? this : new Optional<T>.empty ();
        }
        return this;
    }

    /**
     * Applies the given mapping function if the value is present.
     *
     * @param map_func The mapping function.
     * @return If the value is present, the mapping function will be applied to
     * the value, and an Optional containing the result is returned. Otherwise,
     * returns an empty Optional.
     */
    public Optional<A> map<A> (Gee.MapFunc<A, T> map_func) {
        if (is_present) {
            return new Optional<A>.of_nullable (map_func (value));
        }
        return this;
    }

    /**
     * Applies the given mapping function if the value is present.
     *
     * @param map_func The mapping function.
     * @return If the value is present, the mapping function will be applied to
     * the value, and the optional provided by the function will be returned. 
     * Otherwise, returns an empty Optional.
     */
    public Optional<A> flat_map<A> (Gee.MapFunc<Optional<A>, T> map_func) {
        if (is_present) {
            return map_func (value);
        }
        return this;
    }

    /**
     * Returns the value if present, otherwise the other.
     *
     * @param other The value to return if the optional is empty.
     * @return Returns the value contained by the optional if present,
     * otherwise returns other.
     */
    public T or_else (T other) {
        return is_present ? value : other;
    }

    /**
     * Returns the value if present, otherwise the value supplied by the supplier function.
     *
     * @param supplier The supplier function to invoke if the optional is empty.
     * @return Returns the value contained by the optional if present,
     * otherwise returns the value provided by the supplier function.
     */
    public T or_else_get (SupplyFunc<T> supplier) {
        return is_present ? value : supplier ();
    }

    /**
     * Returns the value if present, otherwise throws an error.
     *
     * @param supplier The supplier function to invoke if the optional is empty.
     * @return Returns the value contained by the optional if present,
     * otherwise throws the error provided by the supplier function.
     */
    public T or_else_throw (SupplyFunc<GLib.Error> supplier) throws GLib.Error {
        if (!is_present) {
            throw supplier ();
        }
        return value;
    }

}
