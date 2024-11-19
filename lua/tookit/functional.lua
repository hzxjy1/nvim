local functional = {}

function functional.map(array, lambda)
	local result = {}
	for i, v in ipairs(array) do
		result[i] = lambda(v)
	end
	return result
end

function functional.reduce(array, lambda, of)
	local accumulate = of
	for _, value in ipairs(array) do
		accumulate = lambda(accumulate, value)
	end
	return accumulate
end

function functional.filter(array, lambda)
	local filtered = {}
	for _, value in ipairs(array) do
		if lambda(value) then
			table.insert(filtered, value)
		end
	end
	return filtered
end

function functional.compose(...)
	local funcs = { ... }
	return function(arg)
		return functional.reduce(funcs, function(acc, f)
			return f(acc)
		end, arg)
	end
end

local function reverse(...)
	local function reverse_h(acc, v, ...)
		if 0 == select("#", ...) then
			return v, acc()
		else
			return reverse_h(function()
				return v, acc()
			end, ...)
		end
	end

	return reverse_h(function() end, ...)
end

function functional.curry(func, num_args, arg_reverse)
	arg_reverse = arg_reverse or false
	if num_args <= 1 then
		return func
	end

	local function curry_h(argtrace, n)
		if 0 == n then
			if arg_reverse then
				return func(argtrace())
			else
				return func(reverse(argtrace()))
			end
		else
			return function(onearg)
				return curry_h(function()
					return onearg, argtrace()
				end, n - 1)
			end
		end
	end

	return curry_h(function() end, num_args)
end

local function arrays_equal(arr1, arr2)
	if #arr1 ~= #arr2 then
		return false
	end
	for i = 1, #arr1 do
		if arr1[i] ~= arr2[i] then
			return false
		end
	end
	return true
end

function functional.test()
	local numbers = { 1, 2, 3, 4, 5 }

	local lambda_map = function(number)
		return number + 1
	end
	local lambda_reduce = function(acc, value)
		return acc + value
	end
	local lambda_filter = function(x)
		return x % 2 == 0
	end

	local mapped_numbers = functional.map(numbers, lambda_map)
	-- lib.print(mapped_numbers)
	assert(arrays_equal(mapped_numbers, { 2, 3, 4, 5, 6 }))
	local reduced_numbers = functional.reduce(numbers, lambda_reduce, 0)
	-- lib.print(reduced_numbers)
	assert(reduced_numbers == 15)
	local filtered_numbers = functional.filter(numbers, lambda_filter)
	-- lib.print(filtered_numbers)
	assert(arrays_equal(filtered_numbers, { 2, 4 }))

	local curried_map = functional.curry(functional.map, 2, true)
	local curried_reduce = functional.curry(functional.reduce, 3, true)
	local composed = functional.compose(curried_map(lambda_map), curried_reduce(0)(lambda_reduce))
	local composed_number = composed(numbers)
	-- lib.print(composed_number)
	assert(composed_number == 20)
end

return functional
