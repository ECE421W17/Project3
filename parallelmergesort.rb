require 'pry'

module ParallelMergeSort

    # TODO: remove prints

    def self.find_correct_index(arr, value)
        # find j such that B[j] <= value <= B[j + 1] using binary search
        return 0 if arr.empty?

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
            

    def self.pmerge(a, b, col, i_start, i_end)
        # merge the arrays a and b into col[i_start..i_end]

        # dummy version - not parallel

        puts "merging #{a} and #{b} into indices #{i_start}, #{i_end}"
        puts "col: #{col}"
        output_size = i_end - i_start + 1

        # without loss of generality, larger array should be first
        return pmerge(b, a, col, i_start, i_end) if b.length > a.length

        if output_size == 1
            col[i_start] = a[0]
        elsif a.empty?
            return
        elsif a.length == 1
            if a[0] <= b[0]
                col[i_start] = a[0]
                col[i_start+1] = b[0]
            else
                col[i_start] = b[0]
                col[i_start+1] = a[0]
            end
        else
            pivot_index = a.length/2
            pivot = a[pivot_index]

            j = find_correct_index(b, pivot) # index that pivot should have in b
            puts "index of value #{pivot} in #{b} is #{j}"

            a_slice1 = a[0..(pivot_index-1)]
            a_slice2 = a[(pivot_index + 1)..(-1)]

            b_slice1 = b[0..j]
            b_slice2 = b[(j+1)..(-1)]

            col_slice1_end = i_start + a_slice1.length + j
            col_slice2_start = col_slice1_end + 2
            col[col_slice1_end + 1] = pivot

            pmerge(a_slice1, b_slice1, col, i_start, col_slice1_end)
            pmerge(a_slice2, b_slice2, col, col_slice2_start, i_end)
        end
    end

    def self.merge(collection, p, q, r)
        first_half_copy = collection[p..q]
        second_half_copy = collection[q+1..r]
        collection.fill(0) # TODO: remove = only for debugging
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
