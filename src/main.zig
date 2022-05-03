const std = @import("std");
const print = std.debug.print;
const napi = @import("./napi.zig");
const allocator = std.heap.c_allocator;
const Parser = @import("./nestedtext/src/nestedtext.zig").Parser;

comptime {
    napi.register(init);
}

fn init(env: napi.env, exports: napi.object) !void {
    try exports.set(env, "encode", try napi.bind.function(env, encode, "encode", allocator));
}

fn encode(env: napi.env, input: napi.string) !napi.string {
    const slice = try input.get(env, .utf8, allocator);
    defer allocator.free(slice);
    var p = Parser.init(allocator, .{});
    var tree = try p.parse(slice);
    defer tree.deinit();
    var json_tree = try tree.root.?.toJson(allocator);
    defer json_tree.deinit();
    var buffer: [1280]u8 = undefined;
    var fbs = std.io.fixedBufferStream(&buffer);
    try json_tree.root.jsonStringify(.{}, fbs.writer());
    return napi.string.new(env, .utf8, fbs.getWritten());
}
