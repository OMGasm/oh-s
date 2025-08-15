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
const ui = @import("ui.zig");

export fn start() void {
    w4.PALETTE.* = .{ 0x100000, 0x554444, 0xAA9A8A, 0xA5CFFF };
}

export fn update() void {
    w4.DRAW_COLORS.* = 1;
    w4.text("Hello from Zig!", 10, 10);
    w4.DRAW_COLORS.* = 2;
    w4.text("Hello from Zig!", 10, 20);
    w4.DRAW_COLORS.* = 3;
    w4.text("Hello from Zig!", 10, 30);
    w4.DRAW_COLORS.* = 4;
    w4.text("Hello from Zig!", 10, 40);

    w4.line(10, 50, 10, 100);
    w4.line(10, 50, 60, 50);
    _ = ui.box(.{ .x = 10, .y = 50 }, .{ .x = 1, .y = 1 }, .{ .border = 2, .bg = 3, .p2type = .size, .bordertype = .inside });
    _ = ui.box(.{ .x = 14, .y = 50 }, .{ .x = 1, .y = 1 }, .{ .border = 2, .bg = 3, .p2type = .size, .bordertype = .outside });
    _ = ui.box(.{ .x = 10, .y = 54 }, .{ .x = 11, .y = 55 }, .{ .border = 2, .bg = 3, .p2type = .point, .bordertype = .inside });
    _ = ui.box(.{ .x = 14, .y = 54 }, .{ .x = 15, .y = 55 }, .{ .border = 2, .bg = 3, .p2type = .point, .bordertype = .outside });
    _ = ui.box(.{ .x = 10, .y = 58 }, .{ .x = 3, .y = 3 }, .{ .border = 2, .bg = 3, .p2type = .size, .bordertype = .inside });
    _ = ui.box(.{ .x = 15, .y = 58 }, .{ .x = 3, .y = 3 }, .{ .border = 2, .bg = 3, .p2type = .size, .bordertype = .outside });
    _ = ui.box(.{ .x = 10, .y = 63 }, .{ .x = 13, .y = 66 }, .{ .border = 2, .bg = 3, .p2type = .point, .bordertype = .inside });
    _ = ui.box(.{ .x = 16, .y = 63 }, .{ .x = 19, .y = 66 }, .{ .border = 2, .bg = 3, .p2type = .point, .bordertype = .outside });

    const foo = ui.box(.{ .x = 25, .y = 55 }, .{ .x = 50, .y = 50 }, .{ .bg = 2, .border = 3, .p2type = .size });
    if (foo.clicked()) {
        w4.DRAW_COLORS.* = 4;
        w4.text("foo!", foo.p1.x + 5, foo.p1.y + 20);
    }
    {
        const d = w4.MOUSE_BUTTONS.* & 1;
        w4.DRAW_COLORS.* = 3 + d;
        const x = w4.MOUSE_X.*;
        const y = w4.MOUSE_Y.*;
        w4.line(x, y, x, y);
    }
}
