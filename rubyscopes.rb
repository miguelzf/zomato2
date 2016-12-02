
foo = "10"

aa = 999

def ttt
	1.times do |i|
		aa = 123
		2.times do |j|
			aa = 234
			puts i.to_s + j.to_s
			puts aa
		end
		puts aa
	end
end

ttt

puts aa


exit

