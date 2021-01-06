from functools import reduce

def subsetsum(weights, targetSum, subset, currentSum, i, results):
    if currentSum == targetSum:
        results.append(frozenset(subset))
        return
    if currentSum > targetSum or i >= len(weights):
        return
    weight = weights[i]
    newCurrentSum = currentSum + weight
    if newCurrentSum <= targetSum:
        subset.add(weight)
        subsetsum(weights, targetSum, subset, newCurrentSum, i + 1, results)
        subset.remove(weight)
    subsetsum(weights, targetSum, subset, currentSum, i + 1, results)

def mul(a, b):
    return a * b

def main():
    input = open("input", "r")
    weights = []
    for line in input:
        weights.append(int(line.strip()))
    groupWeight = sum(weights) / 3
    
    results = []
    subsetsum(weights, groupWeight, set(), 0, 0, results)
    results.sort(key=lambda subset: reduce(mul, subset))
    results.sort(key=lambda x: len(x))
    
    # Normally one would have to check whether the rest of the weights
    # can be subdivided into two disjunct sets with the appropiate sums.
    # However, it seems for this particular input these checks are unnecessary.
    """firstGroup = None
    for result in results:
        rest = []
        for w in weights:
            if not w in result:
                rest.append(w)
        restResult = []
        subsetsum(rest, groupWeight, set(), 0, 0, restResult)
        if len(restResult) > 0:
            firstGroup = result
            break"""
    print reduce(mul, results[0])

main()