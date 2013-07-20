class Capfile
	attr_accessor :capfile_path

	def initialize(capfile_path)
		@capfile_path = capfile_path
	end

	def add(line)
		capfile = File.read(@capfile_path)
		if capfile.include?(line)
			replace = capfile.gsub(/\s*#\s*#{line}\s*/, "\n#{line}\n")
			File.open(@capfile_path, "w") do |cfile|
				cfile.puts replace
			end
		else
			File.open(@capfile_path, "a") do |cfile|
				cfile.puts line
			end
		end
	end

	def assets()
		self.add('load \'deploy/assets\'')
	end

	def negroku()
		self.add("\n# Negroku recipies")
		self.add('require "negroku"')
		self.add('load negroku')
	end

end
