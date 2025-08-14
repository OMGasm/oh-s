const w4 = @import("wasm4.zig");

pub const BoxOpts = struct {
    border: ?u2 = null,
    bg: ?u2 = null,
    bordertype: BorderType = .inside,
    p2type: P2Type = .point,
};

pub const P2Type = enum { point, size };
pub const BorderType = enum { inside, outside };

pub const Point = struct {
    x: i32,
    y: i32,

    pub fn asSize(self: Point) Size {
        return .{ .w = @bitCast(self.x), .h = @bitCast(self.y) };
    }
};

pub const Size = struct {
    w: u32,
    h: u32,

    pub fn asPoint(self: Size) Point {
        return .{ .x = @bitCast(self.w), .y = @bitCast(self.h) };
    }
};

pub const Box = struct {
    p1: Point,
    p2: Point,

    const Self = @This();

    pub fn clicked(self: Self) bool {
        const click = w4.MOUSE_BUTTONS.* == w4.MOUSE_LEFT;
        const x = w4.MOUSE_X.*;
        const y = w4.MOUSE_Y.*;
        return click and
            self.p1.x <= x and x <= self.p2.x and
            self.p1.y <= y and y <= self.p2.y;
    }
};

pub fn box(p1: Point, p2: Point, opts: BoxOpts) Box {
    const offset: i2 = switch (opts.bordertype) {
        .inside => 0,
        .outside => 1,
    };
    const P3: Point = switch (opts.p2type) {
        .point => p2,
        .size => .{
            .x = p1.x + p2.x - (1 - offset),
            .y = p1.y + p2.y - (1 - offset),
        },
    };
    const S3: Size = switch (opts.p2type) {
        .point => .{
            .w = @bitCast(@abs(p2.x - p1.x)),
            .h = @bitCast(@abs(p2.y - p1.y)),
        },
        .size => .{
            .w = @bitCast(p2.x),
            .h = @bitCast(p2.y),
        },
    };
    const P1 = Point{
        .x = p1.x - offset,
        .y = p1.y - offset,
    };

    if (opts.bg) |bg| {
        if (S3.w > 0 and S3.h > 0) {
            w4.DRAW_COLORS.* = bg;
            w4.rect(p1.x, p1.y, S3.w, S3.h);
        }
    }

    if (opts.border) |bc| {
        w4.DRAW_COLORS.* = bc;
        w4.line(P1.x, P1.y, P3.x, P1.y); // top
        w4.line(P1.x, P1.y, P1.x, P3.y); // left
        w4.line(P3.x, P1.y, P3.x, P3.y); // right
        w4.line(P1.x, P3.y, P3.x, P3.y); // bottom
    }

    return Box{ .p1 = P1, .p2 = P3 };
}
