# idemp
My enterprise-grade configuration management and box setup tool... well actually it's just a Bash script.

It provides idempotency, which means you can run your script again and again on the same box without messing up your shiz.

The entirety of the tool is expressed here:

```
function idemp() {
    DEMPODIR="$HOME/.idemp"
    mkdir -p $DEMPODIR
    FLAG="$DEMPODIR/$1"

    if [ ! -f "$FLAG" ]; then
        touch "$FLAG"
        return 0
    else
        return 1
    fi
}
```

With this function in place, you can now use it like this:

```
idemp sayhello && echo "I will only say this once"
```

Notice that no matter how many times you run this command, it only echoes the message once.  That's because idemp creates files in ~/.idemp/ to track what's already been run, and ensures that nothing is run more than once, thus achieving idempotency.

See sample.sh for a heftier example of using idemp to remotely provision a new user over ssh and install Zip and Solr on Ubuntu.

# Q and A

#### How does this tool stack up against enterprise provisioning tools like Chef, Puppet, Ansible, Salt, etc?

Well obviously it's a whole lot simpler.  Like, no learning curve whatsoever besides Bash itself, which is an investment that will yield dividends across many arenas should you choose to learn it.

Feature-wise, this tool allows for the following:

- Idempotency. Add new requirements freely and rerun your script.  Only the new stuff will be executed. 
- EASY debugging, and I mean easy!  It's Bash -- odds are you already know it.  Want to "force" rerun something?  Just delete the tracking file from ~/.idemp/
- You want parallel execution?  Bash has that built-in, just end your command with &
- You want a report of what state your system is in, a list of what has been installed and when it was done?  `ls -l ~/.idemp`
- No black box magic.  You know exactly what the tool is up to.  Black boxes are wonderful as long as they are 100% reliable.  I haven't yet found such a box in the configuration management space.

Idemp has the following drawbacks versus Chef, Puppet, Ansible, Salt, etc:

- It works only on Linux-like systems, eg Unix, BSD, or OS-X 
- For heterogenous environments, the same command may need to be written multiple ways.  Eg on one machine you may need to "yum" while on another you might "apt-get" for the same thing.
    However in my experience the magic "run anywhere" mapping of more advanced tools is overstated -- the magic breaks down a lot the first time you try it on another platform.
- It can't "cleanup and continue" after an aborted execution step.  This tool has no understanding of a transaction, so if a step fails, you must figure out any required cleanup yourself.
    In practice I find this easy and preferable to a black-box transaction, but opinions may differ on this.
- It cannot diagnose and repair a system that was provisioned via other means.  These days with AWS though, boxes are increasingly disposable: many people prefer to just re-build from scratch rather than diagnose and repair
- It is procedural, not declarative.  I consider this an advantage for troubleshooting and reasoning about the system, but philosophies differ on this point.
- No pre-written "easy install" modules to do fancy things (or even simple things).  AWS provisioning, setting up users, network config, and on and on.  You have to do it yourself.  But on the plus side, no vendor lock-in.  Everything is solvable.
- It doesn't have a GUI


Obviously this tool is a quick hack, it is likely not what you need for major 100+ server farms.  But what I see far more frequently is teams with a handful of boxes with modest needs struggling to understand their enterprise management tool when all they really needed was idempotency.  What this tool lacks in features it makes up for in simplicity.  At least it can be used until you outgrow it, which may never happen :)
