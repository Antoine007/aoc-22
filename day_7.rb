def step1(example = false)
  @input = example == 'example' ? @input_example : @input

  @current_directory = 'root'
  @directories = { 'root': new_directory_maker }
  # @parent_directory = 'no'
  make_directories
  reduce
  add_up
  # p @directories
  p @result
end

def step2(example = false)
  @input = example == 'example' ? @input_example : @input

  @current_directory = 'root'
  @directories = { 'root': new_directory_maker }
  # @parent_directory = 'no'
  make_directories
  reduce
  small_deletion
end

def new_directory_maker
  { weight: 0, children: [] }
end

def make_directories
  @input.each do |line|
    next if line.strip == '$ cd /'

    if line[0..6] == '$ cd ..'
      splitted =  @current_directory.split('/')
      splitted.pop
      @current_directory = splitted.join('/')
    elsif line[0..3] == '$ cd'
      new_dir_name = line.split(' ')[2]
      @current_directory += "/#{new_dir_name}"
    elsif line[0..3] == '$ ls'
      next
    elsif line[0..3] == 'dir '
      new_dir_name = line.split(' ')[1]
      new_path = "#{@current_directory}/#{new_dir_name}"
      @directories[@current_directory.to_sym][:children] << new_path
      @directories[new_path.to_sym] = new_directory_maker
    else
      @directories[@current_directory.to_sym][:weight] += line.split(' ')[0].to_i
    end
  end
  # p @directories
end

def all_completed?
  @directories.each do |_k, v|
    return false unless v[:complete]
  end
  true
end

def reduce
  all_completed = false
  # p @directories
  until all_completed
    @directories.each do |_key, val|
      if val[:children].length.zero?
        val[:complete] = true
      elsif @directories[val[:children].last.to_sym][:complete]
        to_remove = @directories[val[:children].last.to_sym]
        val[:weight] += to_remove[:weight]
        val[:children].pop
      else
        next
      end
    end
    all_completed = true if all_completed?
  end
end

def add_up
  @result = 0
  @directories.each do |_key, value|
    @result += value[:weight] if value[:weight] <= 100_000
  end
end

def small_deletion
  ununsed_space = 70_000_000 - @directories[:root][:weight]
  required_deletion = 30_000_000 - ununsed_space

  result = @directories[:root][:weight]
  @directories.each do |_key, value|
    next if value[:weight] <= required_deletion

    result = value[:weight] if value[:weight] < result
  end
  p result
end
