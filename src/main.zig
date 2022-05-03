const std = @import("std");
const print = std.debug.print;
const napi = @import("./napi.zig");
const allocator = std.heap.c_allocator;
const Parser = @import("./nestedtext/src/nestedtext.zig").Parser;

comptime {
    napi.register(init);
}

fn init(env: napi.env, exports: napi.object) !void {
    try exports.set(env, "nt2json", try napi.bind.function(env, nt2json, "nt2json", allocator));
}

fn nt2json(env: napi.env, input: napi.string) !napi.string {
    const slice = try input.get(env, .utf8, allocator);
    defer allocator.free(slice);
    var p = Parser.init(allocator, .{});
    var tree = try p.parse(slice);
    defer tree.deinit();
    var json_tree = try tree.root.?.toJson(allocator);
    defer json_tree.deinit();
    var buffer = std.ArrayList(u8).init(allocator);
    errdefer buffer.deinit();
    try json_tree.root.jsonStringify(.{}, buffer.writer());
    return napi.string.new(env, .utf8, buffer.items);
}
