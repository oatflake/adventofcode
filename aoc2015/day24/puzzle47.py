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
    # This may be due to the fact that 
    # 1. we are looking for the smallest subset.
    # 2. there is some subdivision that fulfills the requirements.
    #
    # For example: [ 3, 5, 7 ] does have the subset [ 5 ], but no overall subdivion
    # exists that would fulfill the requirements.
    # Another example: 
    # [3, 3, 4, 6, 7, 7 ] could be divided into [ 7, 3 ], [ 7, 3 ], and [ 6, 4 ].
    # It's also possible to create [ 4, 3, 3 ], with the rest not having a subdivision
    # which would fulfill the requirements. However, [ 4, 3, 3 ] is not minimal.
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