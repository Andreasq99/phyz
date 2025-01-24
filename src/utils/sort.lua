
function sort(tab)
    local low = 1
    local high = #tab
    quicksort(tab,low,high)
    return tab
end

function quicksort(tab, low, high)
    if low < high then
        pi = partition (tab, low, high)
        quicksort(tab, low, pi-1)
        quicksort(tab, pi+1, high)
    end
end

function partition(tab, low, high)
    local piv = tab[high]    

    i = low - 1
    for j = low,high do
        if tab[j] > piv then
            i = i + 1
            tab[i], tab[j] = tab[j], tab[i]
        end
    end

    tab[i+1], tab[high] = tab[high],tab[i+1]
    return i+1    
end
