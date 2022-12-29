# SPDX-License-Identifier: MIT

module Internals

function assemble_matrix end
function assemble_vector end
function check_n_rows end
function copy_check end
function get_comm end
function get_proc_rows end
function safe_finalizer end
function set_options end
function set_precond end
function set_precond_defaults end
function setup_func end
function solve_func end
function to_hypre_data end

const HYPRE_OBJECTS = WeakKeyDict{Any, Nothing}()

end # module Internals
