/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class DigestView : Gtk.Grid {

    public DigestView () {
        Object (
            row_spacing: 10,
            column_spacing: 10,
            margin: 20
        );
    }

    construct {
        var file_chooser_label = new Gtk.Label ("Select file:") {
            halign = Gtk.Align.END
        };
        var file_chooser_button = new Gtk.FileChooserButton ("Select File\u2026", Gtk.FileChooserAction.OPEN) {
            halign = Gtk.Align.START,
            hexpand = true
        };

        var digest_label = new Gtk.Label ("Choose method:") {
            halign = Gtk.Align.END
        };
        var digest_list_store = new Gtk.ListStore (1, typeof (string));
        var digests = new Gee.HashMap<int, GLib.ChecksumType> ();
        var digests_display_strings = new Gee.HashMap<int, string> ();
        digests.set (0, GLib.ChecksumType.MD5);
        digests_display_strings.set (0, "MD5");
        digests.set (1, GLib.ChecksumType.SHA1);
        digests_display_strings.set (1, "SHA1");
        digests.set (2, GLib.ChecksumType.SHA256);
        digests_display_strings.set (2, "SHA256");
        digests.set (3, GLib.ChecksumType.SHA384);
        digests_display_strings.set (3, "SHA384");
        digests.set (4, GLib.ChecksumType.SHA512);
        digests_display_strings.set (4, "SHA512");
        for (int i = 0; i < digests_display_strings.size; i++) {
            Gtk.TreeIter iter;
            digest_list_store.append (out iter);
            digest_list_store.set (iter, 0, digests_display_strings[i]);
        }

        var digests_combo = new Gtk.ComboBox.with_model (digest_list_store) {
            halign = Gtk.Align.START,
            hexpand = true
        };
        var digests_cell = new Gtk.CellRendererText ();
        digests_combo.pack_start (digests_cell, false);
        digests_combo.set_attributes (digests_cell, "text", 0);
        digests_combo.set_active (0);

        var output_label = new Gtk.Label ("Digest:") {
            halign = Gtk.Align.END
        };
        var output_value = new Gtk.Label ("") {
            halign = Gtk.Align.START,
            ellipsize = Pango.EllipsizeMode.END
        };

        var compute_button = new Gtk.Button.with_label ("Compute") {
            halign = Gtk.Align.START,
            sensitive = false
        };

        attach (file_chooser_label, 0, 0);
        attach (file_chooser_button, 1, 0);
        attach (digest_label, 0, 1);
        attach (digests_combo, 1, 1);
        attach (output_label, 0, 2);
        attach (output_value, 1, 2);
        attach (compute_button, 1, 3);

        file_chooser_button.file_set.connect (() => {
            compute_button.sensitive = true;
        });
        compute_button.clicked.connect (() => {
            var file = GLib.File.new_for_uri (file_chooser_button.get_uri ());
            var checksum_type = digests.get (digests_combo.get_active ());
            try {
                var digest = Catalyst.DigestUtils.compute_for_file (checksum_type, file);
                output_value.set_text (digest);
                output_value.set_tooltip_text (digest);
            } catch (GLib.Error e) {
                output_value.set_text (e.message);
                output_value.set_tooltip_text (e.message);
            }
        });
    }

}
