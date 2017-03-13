
module ParallelMergeSort

    def self.find_correct_index(arr, value, comparison_function)
        # find j such that arr[j] <= value <= arr[j+1]
        idx = (0..arr.size-1).bsearch { |i| comparison_function.call(value, arr[i]) }
        idx ? idx - 1 : arr.length - 1
    end

    def self.pmerge(a, b, c, from, to, comparison_function)
        # merge the arrays a and b into c[from..to]

        output_size = from - to + 1

        if b.length > a.length # without loss of generality, larger array should be first
            self.pmerge(b, a, c, from, to, comparison_function)
        elsif output_size == 1
            c[from] = a[0]
        elsif a.length == 1
            if comparison_function.call(a[0], b[0])
                c[from], c[from + 1] = a[0], b[0]
            else
                c[from], c[from + 1] = b[0], a[0]
            end
        else
            mid_index = a.length/2 - 1
            j = self.find_correct_index(b, a[mid_index], comparison_function)

            a_left = a[0..mid_index]
            b_left = j < 0 ? [] : b[0..j]

            a_right = a[(mid_index+1)..-1]
            b_right = j >= b.length-1 ? [] : b[(j+1)..-1]


            t1 = Thread.new {self.pmerge(a_left, b_left, c, from, from + a_left.length + b_left.length - 1, comparison_function)}
            t2 = Thread.new {self.pmerge(a_right, b_right, c, from + a_left.length + b_left.length, to, comparison_function)}

            t1.join
            t2.join

            while t1.abort_on_exception do
                t1 = Thread.new {self.pmerge(a_left, b_left, c, from, from + a_left.length + b_left.length - 1)}
                puts "recover t1"
            end
            while t2.abort_on_exception do
              t2 = Thread.new {self.pmerge(a_right, b_right, c, from + a_left.length + b_left.length, to)}
              puts "recover t2"
            end
        end
    end

    def self.merge(collection, p, q, r, comparison_function)
        left = (p..q).map { |i| collection[i] }
        right = ((q+1)..r).map { |i| collection[i] }
        self.pmerge(left, right, collection, p, r, comparison_function)
    end

    def self.mergesort(collection, p, r, comparison_function)
        if p < r
            q = (p + r) / 2
            t1 = Thread.new { mergesort(collection, p, q, comparison_function) }
            t2 = Thread.new { mergesort(collection, q+1, r, comparison_function) }
            t1.join()
            t2.join()
            self.merge(collection, p, q, r, comparison_function)
        end
    end
end
