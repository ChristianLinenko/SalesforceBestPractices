public virtual interface IBatchHelper 
{
    Id startJob(Integer jobSpace);
    Boolean shouldIRun();
}