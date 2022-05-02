const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const lib = b.addStaticLibrary("napi.zig", "src/main.zig");
    lib.setBuildMode(std.builtin.Mode.ReleaseFast);
    lib.strip = true;
    lib.linker_allow_shlib_undefined = true;
    lib.emit_bin = .{ .emit_to = "lib.node" };
    lib.linkLibC();
    lib.addIncludeDir("deps/node-v18.0.0/include/node");
    lib.install();
    //const main_tests = b.addTest("src/main.zig");
    //main_tests.setBuildMode(mode);

    //const test_step = b.step("test", "Run library tests");
    //test_step.dependOn(&main_tests.step);
}
