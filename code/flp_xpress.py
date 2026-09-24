import pandas as pd
import xpress as xp

# ---- Data --------------------------------------------------------------
dist  = pd.read_csv("distances.csv", index_col="port")   # d_ij [nm]
ports = pd.read_csv("ports.csv", index_col="port")        # demand d_j [kt/yr]
hubs  = pd.read_csv("hubs.csv", index_col="hub")          # f_i [kEUR/yr], s_i [kt/yr]
c_unit = 0.04                                             # kEUR per (kt nm)

I, J = list(hubs.index), list(ports.index)
cost = {(i, j): c_unit * ports.demand[j] * dist.loc[j, i] for i in I for j in J}

def solve_flp(capacitated=False, single_sourcing=False):
    m = xp.problem("facility_location")
    y = {i: m.addVariable(vartype=xp.binary, name=f"y_{i}") for i in I}
    xtype = xp.binary if single_sourcing else xp.continuous
    x = {(i, j): m.addVariable(lb=0, ub=1, vartype=xtype, name=f"x_{i}_{j}")
         for i in I for j in J}

    m.setObjective(xp.Sum(hubs.fixed_cost[i] * y[i] for i in I)
                   + xp.Sum(cost[i, j] * x[i, j] for i in I for j in J),
                   sense=xp.minimize)
    m.addConstraint(xp.Sum(x[i, j] for i in I) == 1 for j in J)           # serve all
    m.addConstraint(x[i, j] <= y[i] for i in I for j in J)                # open to use
    if capacitated:
        m.addConstraint(xp.Sum(ports.demand[j] * x[i, j] for j in J)
                        <= hubs.capacity[i] * y[i] for i in I)
    m.controls.outputlog = 0
    m.solve()
    opened = [i for i in I if m.getSolution(y[i]) > 0.5]
    return m.attributes.objval, opened, {(i, j): m.getSolution(x[i, j]) for i in I for j in J}

for case in [dict(), dict(capacitated=True), dict(capacitated=True, single_sourcing=True)]:
    z, opened, _ = solve_flp(**case)
    print(case, round(z, 1), opened)
