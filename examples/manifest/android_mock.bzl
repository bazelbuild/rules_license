load("@rules_license//rules:compliance.bzl", "manifest")

"""This is a proof of concept to show how to modify a macro definition to
create a sub-graph allowing for build time injection of license information. We
use Android-inspired rule names since these are a likely candidate for this
sort of injection."""

def android_library(name, **kwargs):
    # This is an approximation for demo purposes.

    data = kwargs.pop("data", [])
    native.filegroup(
        name = name,
        srcs = data + kwargs.get("srcs", []),
    )

    # Inject the data dependency into the library, preserving any other data it has.
    native.sh_library(
        name = name + "_w_licenses",
        data = data + [name + "_manifest.txt"],
        **kwargs
    )

def android_binary(name, **kwargs):
    # Same observation about not being sloppy with mapping deps, but I think the only important attribute
    # in android_binary is deps, but need to double-check.
    native.filegroup(
        name = name + "_no_licenses",
        srcs = kwargs.get("data", []),
    )

    mf_name = name + "_manifest"
    manifest(
        name = mf_name,
        deps = [":" + name + "_no_licenses"],
    )

    # This uses the conditions tool to generate an approximation of a compliance report
    # to demonstrate how license data can be plumbed and made available at build time.
    native.genrule(
        name = "gen_" + name + "_manifest",
        srcs = [":" + mf_name],
        outs = ["licenses_manifest.txt"],
        cmd = "cat $(locations :%s) > $@" % mf_name,
    )

    # Swap out the :licenses dep for our new :licenses_w_licenses dep
    newdeps = []
    deps = kwargs.get("data", [])
    for dep in deps:
        if dep == ":licenses":
            newdeps.append(":licenses_w_licenses")
        else:
            newdeps.append(dep)
    kwargs["data"] = newdeps

    # Compile the executable with the user's originally supplied name, but with the new content.
    native.sh_binary(
        name = name,
        **kwargs
    )
