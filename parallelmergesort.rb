module ParallelMergeSort

    def self.find_correct_index(arr, value)
        # find j such that B[j] <= value <= B[j + 1] using binary search

        i = 0
        j = arr.length-1
        while ((j-i) > 1)
            mid = (i + j) / 2
            if (arr[mid] <= value and value <= arr[mid+1])
                return mid
            end

            if (value <= arr[mid])
                j = mid
            elsif (value >= arr[mid+1])
                i = mid
            end
        end

        if (j == arr.length-1)
            return j
        else
            return i
        end
    end
            

    def self.pmerge(first_half, second_half, col, i_start, i_end)
        # merge the arrays first_half and second_half into col[i_start..i_end]

        # dummy version - not parallel

        output_size = i_end - i_start + 1
        if (second_half.length > first_half.length)
            # without loss of generality, larger array should be first
            return pmerge(second_half, first_half, col, i_start, i_end)
        elsif output_size == 1
            col[p] = a[0]
        elsif first_half.length == 1
            if first_half[0] <= second_half[0]
                col[p] = a[0]
                col[p+1] = b[0]
            else
                col[p] = b[0]
                col[p+1] = a[0]
            end
        else
            j = find_correct_index(second_half, first_half[first_half.length/2])

            first_half1 = first_half[0..(first_half.length/2)]
            second_half1 = second_half[0..j]

            pmerge(first_half1, second_half1, col, i_start, first_half.length/2 + j - 1)

            first_half2 = first_half[(first_half.length/2 + 1)..(first_half.length - 1)]
            second_half2 = second_half[(j+1)..(second_half.length - 1)]

            pmerge(first_half2, second_half2, col, first_half.length/2 + j, i_end)
        end
    end

    def self.merge(collection, p, q, r)
        first_half_copy = collection[p..q]
        second_half_copy = collection[q+1..r]
        pmerge(first_half_copy, second_half_copy, collection, p, r)
    end

    def self.mergesort(collection, p, r)
        if p < r
            q = (p + r) / 2
            t1 = Thread.new { mergesort(collection, p, q) }
            t1 = Thread.new { mergesort(collection, q+1, r) }
            t1.join()
            t2.join()
            merge(collection, p, q, r)
        end
    end

end
