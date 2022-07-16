//  /*
//   * SPDX-License-Identifier: GPL-3.0-or-later
//   * SPDX-FileCopyrightText: 2022 Andrew Vojak <andrew.vojak@gmail.com> (https://avojak.com)
//   */

//  /**
//   * The TextBufferUtils namespace contains useful functions for operating on {@link Gtk.TextBuffer}.
//   */
//  namespace Catalyst.TextBufferUtils {

//      public static bool search_word_in_string (string needle, string haystack, WordMatchDelegate handler) {
//          Gtk.TextBuffer text_buffer = new Gtk.TextBuffer (null) {
//              text = haystack
//          };
//          Gtk.TextIter search_start;
//          Gtk.TextIter search_end;
//          text_buffer.get_end_iter (out search_start);
//          search_start.backward_chars (haystack.length);
//          text_buffer.get_end_iter (out search_end);

//          return search_word_in_buffer (needle, text_buffer, search_start, search_end, handler);
//      }

//      public static bool search_word_in_buffer (string needle, Gtk.TextBuffer text_buffer, Gtk.TextIter start, Gtk.TextIter end, WordMatchDelegate handler) {
//          bool has_match = false;
//          Gtk.TextIter search_start = start;
//          Gtk.TextIter search_end = end;
//          Gtk.TextIter match_start;
//          Gtk.TextIter match_end;
//          while (search_start.forward_search (needle, Gtk.TextSearchFlags.CASE_INSENSITIVE, out match_start, out match_end, search_end)) {
//              if (match_start.starts_word () && match_end.ends_word ()) {
//                  has_match = true;
//                  if (!handler (match_start, match_end)) {
//                      return has_match;
//                  }
//              }
//              search_start = match_end;
//          }
//          return has_match;
//      }

//      // Return whether or not to continue searching after finding a match
//      public delegate bool WordMatchDelegate (Gtk.TextIter match_start, Gtk.TextIter match_end);

//  }