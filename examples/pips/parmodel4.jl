using StructJuMP, JuMP
using StructJuMPSolverInterface

include("select_solver.jl")

scen = 10
m = StructuredModel(num_scenarios=scen)
@variable(m, x[1:2])
@NLconstraint(m, x[1] + x[2] == 100)
@NLobjective(m, Min, x[1]^2 + x[2]^2 + x[1]*x[2])

for i in 1:scen
    bl = StructuredModel(parent=m)
    @variable(bl, y[1:2])
    idx = (isodd(i) ? 1 : 2)
    @NLconstraint(bl, x[idx] + y[1]+y[2] ≥  0)
    @NLconstraint(bl, x[idx] + y[1]+y[2] ≤ 50)
    @NLobjective(bl, Min, y[1]^2 + y[2]^2 + y[1]*y[2])
end

structJuMPSolve(m)

getVarValue(m)

