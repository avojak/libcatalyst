/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class HttpView : Gtk.Grid {

    private Gtk.CssProvider green_progress_provider;
    private Gtk.CssProvider red_progress_provider;

    public HttpView () {
        Object (
            row_spacing: 10,
            column_spacing: 10,
            margin: 20
        );
    }

    construct {
        green_progress_provider = new Gtk.CssProvider ();
        red_progress_provider = new Gtk.CssProvider ();
        try {
            green_progress_provider.load_from_data ("@define-color accent_color @LIME_300;");
            red_progress_provider.load_from_data ("@define-color accent_color @STRAWBERRY_300;");
        } catch (Error e) {
            warning ("Failed to load custom CSS: %s", e.message);
        }

        var url_label = new Gtk.Label ("URL:") {
            halign = Gtk.Align.END
        };
        var url_entry = new Gtk.Entry () {
            halign = Gtk.Align.START,
            hexpand = true
        };

        var file_chooser_label = new Gtk.Label ("Save as:") {
            halign = Gtk.Align.END
        };
        var file_chooser_entry = new Gtk.Entry () {
            halign = Gtk.Align.START,
            hexpand = true,
            secondary_icon_name = "folder-open-symbolic",
            secondary_icon_activatable = true
        };

        var download_button = new Gtk.Button.with_label ("Download") {
            halign = Gtk.Align.START,
            sensitive = false
        };

        var progress_label = new Gtk.Label ("Progress:") {
            halign = Gtk.Align.END
        };

        var progress_bar = new Gtk.ProgressBar () {
            valign = Gtk.Align.CENTER,
            hexpand = true,
            fraction = 0.0,
            show_text = false
        };

        var progress_value = new Gtk.Label ("0MB / ?MB") {
            halign = Gtk.Align.START,
            justify = Gtk.Justification.LEFT,
            ellipsize = Pango.EllipsizeMode.END,
            width_chars = 15
        };

        var progress_grid = new Gtk.Grid () {
            row_spacing = 12,
            column_spacing = 10,
            hexpand = true,
            valign = Gtk.Align.CENTER,
            halign = Gtk.Align.START
        };
        progress_grid.attach (progress_bar, 0, 0);
        progress_grid.attach (progress_value, 1, 0);

        var status_label = new Gtk.Label ("") {
            ellipsize = Pango.EllipsizeMode.END,
            halign = Gtk.Align.START
        };

        attach (url_label, 0, 0);
        attach (url_entry, 1, 0);
        attach (file_chooser_label, 0, 1);
        attach (file_chooser_entry, 1, 1);
        attach (progress_label, 0, 2);
        attach (progress_grid, 1, 2);
        attach (status_label, 1, 3);
        attach (download_button, 1, 4);

        url_entry.changed.connect (() => {
            download_button.sensitive = (url_entry.text.strip ().length > 0)
                && (file_chooser_entry.text.strip ().length > 0);
        });
        file_chooser_entry.changed.connect (() => {
            download_button.sensitive = (url_entry.text.strip ().length > 0)
                && (file_chooser_entry.text.strip ().length > 0);
        });
        file_chooser_entry.icon_press.connect ((icon_pos, event) => {
            if (icon_pos == Gtk.EntryIconPosition.SECONDARY) {
                var dialog = new Gtk.FileChooserDialog ("Save File\u2026", null, Gtk.FileChooserAction.SAVE) {
                    create_folders = true
                };
                dialog.add_button ("Cancel", Gtk.ResponseType.CANCEL);
                dialog.add_button ("Save", Gtk.ResponseType.OK);
                if (dialog.run () == Gtk.ResponseType.OK) {
                    file_chooser_entry.set_text (dialog.get_filename ());
                    download_button.sensitive = (url_entry.text.strip ().length > 0);
                }
                dialog.close ();
            }
        });
        download_button.clicked.connect (() => {
            // Reset the view
            progress_bar.get_style_context ().remove_provider (green_progress_provider);
            progress_bar.get_style_context ().remove_provider (red_progress_provider);
            progress_bar.set_fraction (0.0);
            progress_value.set_text ("0MB / ?MB");
            status_label.set_text ("");

            var context = new Catalyst.Http.DownloadContext (url_entry.text.strip (),
                GLib.File.new_for_path (file_chooser_entry.text.strip ()));
            context.progress.connect ((bytes_read, total_bytes) => {
                Idle.add (() => {
                    progress_bar.set_fraction ((double) bytes_read / (double) total_bytes);
                    progress_value.set_text (get_formatted_progress (bytes_read, total_bytes));
                    return false;
                });
            });
            context.complete.connect (() => {
                Idle.add (() => {
                    progress_bar.get_style_context ().add_provider (green_progress_provider,
                        Gtk.STYLE_PROVIDER_PRIORITY_USER);
                    status_label.set_text ("Complete");
                    return false;
                });
            });
            context.failed.connect ((message, status_code) => {
                Idle.add (() => {
                    progress_bar.set_fraction (1.0);
                    progress_bar.get_style_context ().add_provider (red_progress_provider,
                        Gtk.STYLE_PROVIDER_PRIORITY_USER);
                    status_label.set_text ("Failed: %s".printf (message));
                    return false;
                });
            });
            Catalyst.HttpUtils.download_file_async.begin (context, null, (obj, res) => {
                Catalyst.HttpUtils.download_file_async.end (res);
            });
        });
    }

    private string get_formatted_progress (int64 total_read, int64 total_size) {
        double read_mb = ((double) total_read) / 1000000.0;
        double total_mb = ((double) total_size) / 1000000.0;
        return "%.1fMB / %.1fMB".printf (read_mb, total_mb);
    }

}
