using BinaryProvider # requires BinaryProvider 0.3.0 or later
using Libdl

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libglmnet"], :libglmnet),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JackDunnNZ/GLMNetBuilder/releases/download/v5-2"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.aarch64-linux-gnu-gcc4.tar.gz", "2d2806621bfe1e8cfedf33b061e5a1bfe89a5bc8e8f272179b36b3e5e1ad3428"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.aarch64-linux-gnu-gcc7.tar.gz", "ea0172b95b52a0b4285c8851d3c9de37c972aad6132ff395447d8dc50ea8542b"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.aarch64-linux-gnu-gcc8.tar.gz", "bb4387b4de50a483a621d2fe772ae8d1362377094ba85b78839f7f385c743cdc"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.aarch64-linux-musl-gcc4.tar.gz", "8b684072f3c4350f477bfaec305e5b3e211f2a30d60d151780333effb636da06"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.aarch64-linux-musl-gcc7.tar.gz", "4cdc64a24e3fea0eef697aeda333a21c95d328a33cc528ddd1c31014a09eb987"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.aarch64-linux-musl-gcc8.tar.gz", "56cf7f155bd24674266b10a5ebe3a8cd8ed3648f3bd02ba663fd8119533e7fa9"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.arm-linux-gnueabihf-gcc4.tar.gz", "009f7bfa3ebd435b1788e91d3965b8f0346076a1fbce1fc7c81a8981cd6a3c61"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.arm-linux-gnueabihf-gcc7.tar.gz", "362a505e5b4e983453f4609f415131cd8991e6fb7dcbbf643868dda731cb7275"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.arm-linux-gnueabihf-gcc8.tar.gz", "fde5e90b8c6b2f1abf8c6db8c554068028127c6d02393fd805d9dcc67af3681d"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.arm-linux-musleabihf-gcc4.tar.gz", "d1d05887bd93182ce0615c2ef4682b3e90d1d7b28c48486537c793d6184719cc"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.arm-linux-musleabihf-gcc7.tar.gz", "b990be3b0707821c59547be9de26b316c7ad4cd197dcb2b5fbdec382d57810e3"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.arm-linux-musleabihf-gcc8.tar.gz", "7a4e00c29fccf4355711a59d5bf280c3d81113a7ae572fb445f62908c82d275b"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.i686-linux-gnu-gcc4.tar.gz", "d84b0c966570dbb4f42090e52120cc1ede1d652a590f9488422a0de7702b2222"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.i686-linux-gnu-gcc7.tar.gz", "001c8e093539f04316477ba6a513f10e8af1d0c432ae9fe80badd040b4736108"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.i686-linux-gnu-gcc8.tar.gz", "1c58646892cb29a9631c2cb1f1e7e3e6515d26ce75ce8d4e21cc51ebf9a5b17b"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.i686-linux-musl-gcc4.tar.gz", "da76045fbe3d38d379ca6383d915798de7c722f0e370fca7b539ae6f7e3de39d"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.i686-linux-musl-gcc7.tar.gz", "826f1e3cca812a9bfb95c8e3a58797e69e6483f9a254ca7b5e386ca343cbd881"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.i686-linux-musl-gcc8.tar.gz", "a4c10543345b66870cd5ebc9fbf617b16388c0e88db59d05d5a208bde33d7a87"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.i686-w64-mingw32-gcc4.tar.gz", "0d65da43813af68ce685df0826a88d518cc6f619e5c3fdb6b1d71996bf8b35b5"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.i686-w64-mingw32-gcc7.tar.gz", "f4a02ed99d53df193779ed7d10c087c47cf440f0f9ff1f9b93b6564a03ca74b2"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.i686-w64-mingw32-gcc8.tar.gz", "f748f5fc3b2e9e46761ef70ff47e527925af91369b4ebcbd37253bcf575c13dc"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.powerpc64le-linux-gnu-gcc4.tar.gz", "0b9020dae84c899e1491f077e1823c99d03f05599810fb473fb83bf3118e0b26"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.powerpc64le-linux-gnu-gcc7.tar.gz", "05ab161682d60776aaaa9f3d2f9d060d160565da4aff62063a5d2c7ab6f93de7"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.powerpc64le-linux-gnu-gcc8.tar.gz", "2c8141ea4a95c6ad67c8eb3ed4a1c77fa50c05bc2b1ed027aa6f29dc81ed5d48"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-apple-darwin14-gcc4.tar.gz", "1679227f30ecf26ecc6a2e9b02acdfeb99444e335407cc026d002d28a9437544"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-apple-darwin14-gcc7.tar.gz", "279c5a8b8fbf0e6c1252dda05d1cdbdb6840cc0560a2107df19368b10d90a3b6"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-apple-darwin14-gcc8.tar.gz", "f25c11763c66c2b8b0b4dce828a0c48cf09a90a7e844b88a1d1bc885bdd5c6a6"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-linux-gnu-gcc4.tar.gz", "01b344df4f986c3c85a65f6afe2973e8bf98b17c0417ee1f1814a3e878b403ee"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-linux-gnu-gcc7.tar.gz", "ea3faa8f7fb57a44ed62da52869321e14ddda390077653c55300db6db1101df9"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-linux-gnu-gcc8.tar.gz", "a9a8f2c7887706efb8f7a8f4aa28a3fb4057e23b6874db6b2b7511fbfa70ed4f"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-linux-musl-gcc4.tar.gz", "8f7cd82195a9e6a75ea3775cbf4dc9aeb5d3b8205fe2cb9f7651aecadc48db68"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-linux-musl-gcc7.tar.gz", "ac0cd26f829b144375e0e77331ebdb478e3f889515f11f0b51aad8e77e514041"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-linux-musl-gcc8.tar.gz", "56dddbda94b4f2c0d369e77e07d779627c4a9639f63280408283510ca0fcfb86"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-unknown-freebsd11.1-gcc4.tar.gz", "764a88a922a822b734c512cc98e57aa26e86a0df2eba5a821bb50cb577737a7c"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-unknown-freebsd11.1-gcc7.tar.gz", "8eed3fec2a44d5716ca8bc38063926e26435398bbff5f4c51366f4f0d229fb76"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-unknown-freebsd11.1-gcc8.tar.gz", "76beb84defdde23ca70d61903dfa340e3871aa89ed8b1e70fbba3d5c20bbe287"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-w64-mingw32-gcc4.tar.gz", "08154fd8ffcb54cdf8eac064953a65a9c9ca2b8ef1fb7d2f346df3f7fcb06ab9"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-w64-mingw32-gcc7.tar.gz", "2dc11f5ed659b461fd0f9744752fc68a830a307dcaab36ea9b67391b0d53a7a6"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/GLMNet.v5.0.0.x86_64-w64-mingw32-gcc8.tar.gz", "5760d8b3a079410e245fabbe9d9affd67d353dc6870cde6457eb4bd72eae4c85"),
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    @warn "GLMNetBuilder provides no prebuilt binary for your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\")."

    @info "Trying to install GLMNet from source, assuming you have gfortran available"

    if Sys.iswindows()
        flags = ["-m$(Sys.WORD_SIZE)","-fdefault-real-8","-ffixed-form","-shared","-O3"]
    else
        flags = ["-m$(Sys.WORD_SIZE)","-fdefault-real-8","-ffixed-form","-shared","-O3","-fPIC"]
    end

    run(`gfortran $flags glmnet5.f90 -o libglmnet.$(Libdl.dlext)`)

    write(joinpath(@__DIR__, "deps.jl"), """
        if isdefined((@static VERSION < v"0.7.0-DEV.484" ? current_module() : @__MODULE__), :Compat)
            import Compat.Libdl
        elseif VERSION >= v"0.7.0-DEV.3382"
            import Libdl
        end

        function check_deps()
            global libglmnet
            if !isfile(libglmnet)
                error("\$(libglmnet) does not exist, Please re-run Pkg.build(\\\"GLMNet\\\"), and restart Julia.")
            end

            if Libdl.dlopen_e(libglmnet) in (C_NULL, nothing)
                error("\$(libglmnet) cannot be opened, Please re-run Pkg.build(\\\"GLMNet\\\"), and restart Julia.")
            end

        end
        const libglmnet = "$(joinpath(@__DIR__, "libglmnet.$(Libdl.dlext)"))"
    """)
else
    # If we have a download, and we are unsatisfied (or the version we're
    # trying to install is not itself installed) then load it up!
    if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
        # Download and install binaries
        install(dl_info...; prefix=prefix, force=true, verbose=verbose)
    end

    # Write out a deps.jl file that will contain mappings for our products
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
end
