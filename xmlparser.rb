#Simple XML parser
#TODO: file handling, Tk GUI, XML structure export, JSON export
require "benchmark"

def xmlParser(xml)
	xml=xml.scan(/./)									#split each letter to array (incl. whitespace)
	att=""												#att (aka node) being "produced"
	attActive=0											#is an att being produced?
	level=0												#depth
	arr=[]												#output array
	isComment=0											#part of the XML being parsed is a comment?
	w=""												#previous char, relative to x
	
	xml.each{ |x|										#originally: for x in 0...xml.length
		case x
			when "<" then
				attActive=1 if isComment==0				#start producing new att (that's not within a <!-- comment -->)
			when "?" then								
				attActive=0 if w=="<"					#it's a <? node, cancel producing
			when "!" then								
				attActive=0 if w=="<"					#it's a <!-- comment, cancel producing
			when "-" then
				isComment=1 if w=="!"
			when ">" then								#close new att
				if attActive==1 && isComment==0			#when producing and it's not a node whitin a <!-- comment -->
					att.split							#remove leading and trailing whitespaces
					att.gsub!(/\s+/, " ")				#replace long whitespaces with single space (needed to preserve when node has properties)
					
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
					
					level-=1 if attIsSingle					#if this has been a single att, decr. level by 1
					att=""									#empty the att when done with producing an att
				end
				isComment=0 if (w=="-" && isComment==1)
			else att<<x if attActive==1					#produce: concat current letter with att
		end
		w=x
	}
	
	arr													#return arr
end

inputXml = '<?xml version="1.0" encoding="windows-1252"?>
<!-- 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
THIS IS A DESCRIPTION
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Lorem ipsum http://link.tld

-->
<ROOT-NODE>
	<NODE1 attr="text1" attr2="text2">
		<!-- node in comment: <DONT_SHOW_THIS>-->
		<SUBNODE1>100712345678901</SUBNODE1>
		<SUBNODE2>TEXT</SUBNODE2>
		<!-- multiline comment 
			  XML1  ==> xml1
			  TXML  ==> txml
		-->
		<SUBNODE3>1059</SUBNODE3>
	</NODE1>
	<NODE2/>
	<NODE3 />
	<NODE 4>
	<NODE5 />
	<NODE6 attr="_blank" />
</ROOT-NODE>

'

#method call with benchmarking
method_time = Benchmark.realtime do
	xmlParser(inputXml)
end

puts "Parsing took "+method_time.to_s+" seconds"
