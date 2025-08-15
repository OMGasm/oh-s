// oh-s
// Copyright (C) 2025  OMGasm
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

const w4 = @import("wasm4.zig");

const Wrap_s = enum {
    none,
    normal,
    hyphenate,
};

const Align_s = union(enum) {
    left,
    center: struct { width: u8 },
    right: struct { width: u8 },
};

const Options_s = struct {
    spacing: u5 = 1,
    vspacing: u5 = 1,
    wrap: Wrap_s = .none,
    alignment: Align_s = .left,
    justify: bool = false,
    max_width: u8 = 160,
    max_height: u8 = 160,
};

pub fn with_font(comptime font_module: type) type {
    return struct {
        const Options = Options_s;
        const Align = Align_s;
        const Wrap = Wrap_s;

        pub fn char(c: u8, x: i32, y: i32) !void {
            const map = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_[])!@#$%^&*(-{}.,/\\?\"':;|<>=";
            const i = for (map, 0..) |m, i| {
                if (c == m) {
                    break i;
                }
            } else {
                return error.NotFound;
            };
            const X = i % 13;
            const Y = i / 13;

            w4.blitSub(&font_module.font, x, y, 3, 5, 1 + 4 * X, 1 + 6 * Y, font_module.width, font_module.flags);
        }

        pub fn text(str: []const u8, x: i32, y: i32, opts: Options) void {
            const w = 3 + opts.spacing;
            const h = 5 + opts.vspacing;

            var y2 = y;
            var x2 = x;
            loop: for (str) |c| {
                switch (c) {
                    '\n' => {
                        x2 = x;
                        y2 += h;
                    },
                    else => {
                        char(c, x2, y2) catch {};
                        x2 += w;
                        switch (opts.wrap) {
                            .none => {
                                if (x2 > x + opts.max_width) {
                                    break :loop;
                                }
                            },
                            .normal => {
                                if (x2 > x + opts.max_width) {
                                    y2 += h;
                                    x2 = x;
                                }
                            },
                            .hyphenate => {},
                        }
                    },
                }
                if (y2 > opts.max_height + y - h) {
                    break;
                }
            }
        }
    };
}
