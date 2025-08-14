const std = @import("std");

const test_targets = [_]std.Target.Query{
    .{},
};

pub fn build(b: *std.Build) !void {
    const exe = b.addExecutable(.{
        .name = "cart",
        .root_source_file = b.path("src/main.zig"),
        .target = b.resolveTargetQuery(.{
            .cpu_arch = .wasm32,
            .os_tag = .freestanding,
        }),
        .optimize = .ReleaseSmall,
    });

    exe.entry = .disabled;
    exe.root_module.export_symbol_names = &[_][]const u8{ "start", "update" };
    exe.import_memory = true;
    exe.initial_memory = 65536;
    exe.max_memory = 65536;
    exe.stack_size = 14752;

    b.installArtifact(exe);

    const run_exe = b.addSystemCommand(&.{ "npx", "w4", "run" });
    const run_exe_hot = b.addSystemCommand(&.{ "npx", "w4", "run", "--hot" });
    run_exe.addArtifactArg(exe);
    run_exe_hot.addArtifactArg(exe);

    const step_run = b.step("run", "compile and run the cart");
    const step_run_hot = b.step("run_hot", "compile and run the cart");
    step_run.dependOn(&run_exe.step);
    step_run_hot.dependOn(&run_exe_hot.step);
}
