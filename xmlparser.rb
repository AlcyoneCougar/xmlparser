#Simple XML parser
#TODO: file handling, Tk GUI, XML structure export, JSON export
require "benchmark"

def xmlParser(xml)
	xml=xml.gsub(/\s+/, "").scan(/./)					#remove whitespace and split each letter to array		
	att=""												#att (aka node) being "produced"
	attActive=0											#is an att being produced?
	level=0												#depth
	arr=[]												#output array
	
	xml.each{ |x|										#originally: for x in 0...xml.length
		case x
			when "<" then attActive=1					#start producing new att
			when ">" then								#close new att
				
				if att[0]!="!" && att[0]!="?"			#if att is not a comment
					att[0]!="/" ? level+=1 : level-=1	#calculate level
					
					att[-1,1]=="/" ? attIsSingle=true : attIsSingle=false	#single att, e.g. <br/>?
					
					if att[0]!="/"						#if not e.g. "/a"
						att.chomp!("/")					#chomp here removes "/", e.g. "br/" -> "br"
						arr<<att						#push to array, originally: arr[index]=att
						level.times{print "-"}
						puts att									#display att
						#puts "#{att} \[level #{level}\]"			#display att with level
					end
					attActive=0							#not producing att right now
					
					level-=1 if attIsSingle				#if this has been a single att, decr. level by 1
				end
				att=""									#empty the att when done with producing an att
			else att<<x if attActive==1					#produce: concat current letter with att
		end
	}
	
	arr													#return arr
end

inputXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!-- this is a comment -->
	<FURRIES>
		<FURRY>
			<NAME>Alcyone</NAME>
			<SPECIES>Cougar</SPECIES>
			<EMPTYNODE/><!-- empty node for testing -->
		</FURRY>
	</FURRIES>"

#method call with benchmarking
method_time = Benchmark.realtime do
	xmlParser(inputXml)
end

puts "Parsing took "+method_time.to_s+" seconds"
