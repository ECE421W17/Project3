require 'pry'

module ParallelMergeSort

    # TODO: remove prints

    def self.find_correct_index(arr, value)
        low = 0
        high = arr.length - 1
        while low < (high - 1)
            mid = (low + high) / 2

            if value <= arr[mid]
                high = mid
            elsif value > arr[mid]
                low = mid
            end
        end
        low
    end
            
    def self.pmerge(a, b, c, from, to)
        # merge the arrays a and b into c[from..to]

        # dummy version - not parallel

        output_size = from - to + 1

        puts "merging #{a} and #{b} into indices #{from}, #{to}"
        puts "c: #{c}"
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
            puts "value of j for #{b} and #{a[mid_index]} is #{j}"

            a_left = a[0..mid_index]
            b_left = b[0..j]
            self.pmerge(a_left, b_left, c, from, from + a_left.length + b_left.length - 1)

            a_right = a[(mid_index+1)..-1]
            b_right = b[(j+1)..-1]
            self.pmerge(a_right, b_right, c, from + a_left.length + b_left.length, to)
        end

    end

    def self.merge(collection, p, q, r)
        first_half = collection[p..q]
        second_half = collection[q+1..r]
        collection.fill(0) # TODO: remove; debug only
        self.pmerge(first_half, second_half, collection, p, r)
    end

    def self.mergesort(collection, p, r)
        if p < r
            q = (p + r) / 2
            t1 = Thread.new { mergesort(collection, p, q) }
            t2 = Thread.new { mergesort(collection, q+1, r) }
            t1.join()
            t2.join()
            merge(collection, p, q, r)
        end
    end

end
