using CodecZlib

infile = ARGS[1]
outfile = ARGS[2]

stream = GzipDecompressorStream(open(expanduser(infile)))

regex1 = r">"
regex2 = r"plasmid|Candidatus|partial|chromosome.*(II|[2-9])"

open(outfile, "w") do fp
  HOST=0
  for line in eachline(stream)
    if occursin(regex1, line)
      HOST=0
      if !occursin(regex2, line)
        write(fp, line*"\n")
        HOST=1
      end
    else
      if HOST == 1
        write(fp, line*"\n")
      end
    end
  end
end

close(stream)
