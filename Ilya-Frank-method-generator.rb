def correct?(lineEng)
  if (
    lineEng.end_with?(".\n" ) or
    lineEng.end_with?(".”\n") or
    lineEng.end_with?("?”\n") or
    lineEng.end_with?("?\n" ) or
    lineEng.end_with?("!\n" ) or
    lineEng.end_with?("!”\n") or
    lineEng.end_with?(".’\n") or
    lineEng.end_with?("!’\n") or
    lineEng.end_with?("?’\n") or
    lineEng.end_with?("-“\n")
  ) and lineEng.size > $desiredEngLineSize
    if $offsetsHash[$number] < 0
      $offsetsHash[$number] += 1
      false
    else
      true
    end
  else
    false
  end
end

def correct2?
  if $offsetsHash[$number] > 0
    $offsetsHash[$number] -= 1
    true
  else
    false
  end
end


begin
  rus = File.open("curDataRus", "r:UTF-8")
  eng = File.open("curDataEng", "r:UTF-8")
  output = File.open("RusEng_Worm.txt", "w:UTF-8")

  lenEng = 0
  engPoints = 0
  rusPoints = 0
  $desiredEngLineSize = 179
  $number = 1
  $offsetsHash = {
    11 => -1,
    13 => -1
  }
  $offsetsHash.default = 0

  eng.each_line("\n") do |lineEng|
    output.print (lineEng = lineEng.encode('utf-8'))

    # maybe should add some lines of the old version here

    engPoints += lineEng.scan(/([.!?])|(-“)/).size
    lenEng += lineEng.length
    if correct?(lineEng)
      output.puts
      output.puts lineRus = rus.readline("\n\n")
      rusPoints += lineRus.scan(/[.!?]/).size
      lenRus = lineRus.length
      while (lenRus.to_f / lenEng < 0.78 and lenEng > 90 or
             lineRus.end_with?(":\n\n") or
             lenRus.to_f / lenEng < 0.52 or
             rusPoints < engPoints and (lenRus.to_f / lenEng < 0.83) or
             correct2?)
        lineRus = rus.readline("\n\n")
        rusPoints += lineEng.scan(/[.!?]/).size
        output.puts lineRus
        lenRus += lineRus.length
      end

      lenEng = 0
      engPoints = 0
      rusPoints = 0
      $number += 1
      output.puts "-----#{$number}"
      output.puts "-----"
    end
  end

rescue  => e
  puts "Error: #{e}"
  p e.backtrace
  gets
ensure
  rus.close
  eng.close
  output.close
end

