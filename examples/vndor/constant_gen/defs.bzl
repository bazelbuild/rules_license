# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""A trivial rule to turn a string into a C++ constant."""

def _constant_gen_impl(ctx):
    # Turn text into a C++ constant.
    outputs = [ctx.outputs.src_out]
    ctx.actions.run(
        mnemonic = "GenerateConstant",
        progress_message = "Generating %s" % ctx.attr.var,
        outputs = outputs,
        executable = ctx.executable._generator,
        arguments = [ctx.outputs.src_out.path, ctx.attr.var, ctx.attr.text],
    )
    return [DefaultInfo(files = depset(outputs))]

_constant_gen = rule(
    implementation = _constant_gen_impl,
    attrs = {
        "src_out": attr.output(mandatory = True),
        "text": attr.string(mandatory = True),
        "var": attr.string(mandatory = False),
        "_generator": attr.label(
            default = Label("@rules_license//examples/vndor/constant_gen:constant_generator"),
            executable = True,
            allow_files = True,
            cfg = "exec",
        ),
    },
)

def constant_gen(name, text, var):
    # Generate the code
    _constant_gen(
        name = name + "_src_",
        src_out = name + "_src_.cc",
        text = text,
        var = var,
        applicable_licenses = ["@rules_license//examples/vndor/constant_gen:license_for_emitted_code"],
    )

    # And turn it into a library we can link against
    native.cc_library(
        name = name,
        srcs = [name + "_src_"],
        applicable_licenses = ["@rules_license//examples/vndor/constant_gen:license_for_emitted_code"],
    )
