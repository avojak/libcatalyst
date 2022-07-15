/*
 * SPDX-License-Identifier: GPL-3.0-or-later
 * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
 */

public class Catalyst.Demo : Gtk.Application {

    construct {
        application_id = "com.github.avojak.catalyst.demo";
        flags = ApplicationFlags.FLAGS_NONE;
    }

    public override void activate () {
        var window = new Gtk.Window ();

        var main_stack = new Gtk.Stack ();
        main_stack.add_titled (new DigestView (), "digest", "DigestUtils");
        main_stack.add_titled (new HttpView (), "http", "HttpUtils");

        var stack_sidebar = new Gtk.StackSidebar ();
        stack_sidebar.stack = main_stack;

        var paned = new Gtk.Paned (Gtk.Orientation.HORIZONTAL) {
            position = 240
        };
        paned.pack1 (stack_sidebar, false, false);
        paned.pack2 (main_stack, true, false);

        window.add (paned);
        window.set_default_size (600, 400);
        window.set_size_request (600, 400);
        window.title = "Catalyst Demo";

        add_window (window);
        window.show_all ();
    }

    public static int main (string[] args) {
        return new Catalyst.Demo ().run (args);
    }

}
