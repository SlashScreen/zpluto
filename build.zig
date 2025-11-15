const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const pluto_dep = b.dependency("pluto_lang", .{});

    const lib = b.addLibrary(
        .{
            .name = "zpluto",
            .linkage = .static,
            .root_module = b.createModule(
                .{
                    .target = target,
                    .optimize = optimize,
                    .link_libcpp = true,
                },
            ),
        },
    );

    lib.addCSourceFiles(.{
        .root = pluto_dep.path("src"),
        .files = &.{
            "lapi.cpp",
            "lassertlib.cpp",
            "lauxlib.cpp",
            "lbase32.cpp",
            "lbase64.cpp",
            "lbaselib.cpp",
            "lbigint.cpp",
            "lbufferlib.cpp",
            "lcanvas.cpp",
            "lcatlib.cpp",
            "lcode.cpp",
            "lcorolib.cpp",
            "lcryptolib.cpp",
            "lctype.cpp",
            "ldblib.cpp",
            "ldebug.cpp",
            "ldo.cpp",
            "ldump.cpp",
            "lffi.cpp",
            "lfunc.cpp",
            "lgc.cpp",
            "lhttplib.cpp",
            "linit.cpp",
            "liolib.cpp",
            "ljson.cpp",
            "llex.cpp",
            "lmathlib.cpp",
            "lmem.cpp",
            "loadlib.cpp",
            "lobject.cpp",
            "lopcodes.cpp",
            "loslib.cpp",
            "lparser.cpp",
            "lregex.cpp",
            "lschedulerlib.cpp",
            "lsocketlib.cpp",
            "lstarlib.cpp",
            "lstate.cpp",
            "lstring.cpp",
            "lstrlib.cpp",
            "ltable.cpp",
            "ltablib.cpp",
            "ltm.cpp",
            "lua.cpp",
            "luac.cpp",
            "lundump.cpp",
            "lurllib.cpp",
            "lutf8lib.cpp",
            "lvector3lib.cpp",
            "lvm.cpp",
            "lxml.cpp",
            "lzio.cpp",
        },
    });

    var translate_header = b.addTranslateC(.{
        .link_libc = true,
        .root_source_file = pluto_dep.path("src/lua.h"),
        .target = target,
        .optimize = optimize,
    });
    translate_header.defineCMacro("noexcept", "");
    const t_mod = translate_header.addModule("pluto");
    t_mod.linkLibrary(lib);

    b.installArtifact(lib);
}
