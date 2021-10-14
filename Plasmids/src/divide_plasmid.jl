using CodecZlib

infile = ARGS[1]
outfile = ARGS[2]

stream = GzipDecompressorStream(open(expanduser(infile)))

regex1 = r">"
regex2 = r"plasmid"

open(outfile, "w") do fp
  PLASMID=0
  for line in eachline(stream)
    if occursin(regex1, line)
      PLASMID=0
      if occursin(regex2, line)
        write(fp, line*"\n")
        PLASMID=1
      end
    else
      if PLASMID == 1
        write(fp, line*"\n")
      end
    end
  end
end

close(stream)
