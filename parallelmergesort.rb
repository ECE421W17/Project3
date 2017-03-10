
module ParallelMergeSort

    # A parallel implementation of mergesort based on
    # Cormen et al., Introduction to Algorithms, 3rd ed.,
    # MIT Press, Cambridge, MA, USA

    def self.binary_search(value, arr, i_start, i_end)
        # find the largest index q such that arr[q-1] < value

        low = i_start
        high = [i_start, i_end+1].max

        while (low < high)
            mid = (low + high) / 2
            if value <= arr[mid]
                high = mid
            else
                low = mid + 1
            end
        end

        high
    end
            

    def self.pmerge(from, p1, r1, p2, r2, to, p3)
        # merge in parallel the arrays from[p1..r1] and from[p2..r2] 
        # into the array slice starting at to[p3]

        size1 = r1 - p1 + 1
        size2 = r2 - p2 + 1
        if size1 < size2 # the first array should be the largest
            self.pmerge(from, p2, r2, p1, r1, to, p3)
        end

        if size1 == 0 # both empty
            return
        else
            mid_slice1 = (p1 + r1) / 2
            index_in_slice2 = self.binary_search(from[mid_slice1], from, p2, r2)
            division_index = p3 + (mid_slice1 - p1) + (index_in_slice2 - p2)
            to[division_index] = from[mid_slice1]

            t1 = Thread.new { self.pmerge(from, p1, mid_slice1 - 1, p2, index_in_slice2 - 1, to, p3) }
            t2 = Thread.new { self.pmerge(from, mid_slice1 + 1, r1, index_in_slice2, r2, to, division_index + 1) }
            t1.join
            t2.join
        end
    end

    def self.merge(collection, p, q, r)
        backup = collection[p..r]
        self.pmerge(backup, 0, q - p, q - p + 1, r - p, collection, p)
    end

    def self.mergesort(collection, p, r)
        if p < r
            q = (p + r) / 2
            t1 = Thread.new { self.mergesort(collection, p, q) }
            t2 = Thread.new { self.mergesort(collection, q+1, r) }
            t1.join()
            t2.join()
            merge(collection, p, q, r)
        end
    end

end
