
module ParallelMergeSort

    def self.find_correct_index(arr, value)
        # find j such that arr[j] <= value <= arr[j+1]
        i = arr.bsearch_index {|x| value <= x}
        i ? i - 1 : arr.length - 1
    end
            
    def self.pmerge(a, b, c, from, to)
        # merge the arrays a and b into c[from..to]

        output_size = from - to + 1

        if b.length > a.length # without loss of generality, larger array should be first
            self.pmerge(b, a, c, from, to)
        elsif output_size == 1
            c[from] = a[0]
        elsif a.length == 1
            if a[0] < b[0]
                c[from], c[from + 1] = a[0], b[0]
            else
                c[from], c[from + 1] = b[0], a[0]
            end
        else
            mid_index = a.length/2 - 1
            j = self.find_correct_index(b, a[mid_index])

            a_left = a[0..mid_index]
            b_left = j < 0 ? [] : b[0..j]

            a_right = a[(mid_index+1)..-1]
            b_right = j >= b.length-1 ? [] : b[(j+1)..-1]

            t1 = Thread.new {self.pmerge(a_left, b_left, c, from, from + a_left.length + b_left.length - 1)}
            t2 = Thread.new {self.pmerge(a_right, b_right, c, from + a_left.length + b_left.length, to)}

            t1.join
            t2.join
        end

    end

    def self.merge(collection, p, q, r)
        left = collection[p..q]
        right = collection[q+1..r]
        self.pmerge(left, right, collection, p, r)
    end

    def self.mergesort(collection, p, r)
        if p < r
            q = (p + r) / 2
            t1 = Thread.new { mergesort(collection, p, q) }
            t2 = Thread.new { mergesort(collection, q+1, r) }
            t1.join()
            t2.join()
            self.merge(collection, p, q, r)
        end
    end

end
